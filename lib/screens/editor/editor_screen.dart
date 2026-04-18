import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:status_hub/widgets/giphy_picker_sheet.dart';
import 'dart:io';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_fonts.dart';
import '../../providers/editor_provider.dart';
import 'dart:ui' as ui;

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final GlobalKey _canvasKey = GlobalKey();
  late TextEditingController _textController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final provider = context.read<EditorProvider>();
    _textController = TextEditingController(text: provider.editedText);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<Uint8List?> _captureCanvas() async {
    try {
      final RenderRepaintBoundary boundary =
          _canvasKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      return byteData?.buffer.asUint8List();
    } catch (e) {
      return null;
    }
  }

  Future<void> _saveToGallery() async {
    setState(() => _isSaving = true);
    try {
      final Uint8List? image = await _captureCanvas();
      if (image == null) return;

      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/status_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(image);

      await SaverGallery.saveImage(
        image,
        name: 'status_${DateTime.now().millisecondsSinceEpoch}',
        androidRelativePath: 'Pictures/StatusHub',
        androidExistNotSave: true,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved to gallery!', style: GoogleFonts.poppins()),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _shareStatus() async {
    try {
      final Uint8List? image = await _captureCanvas();
      if (image == null) return;

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/status_share.png');
      await file.writeAsBytes(image);

      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'Made with Status Hub 🔥');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to share: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [_buildCanvas(), _buildToolbar(), _buildBottomActions()],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: AppColors.textPrimary,
          size: 20,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Edit Status',
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: () => context.read<EditorProvider>().reset(),
          icon: const Icon(
            Icons.refresh,
            size: 16,
            color: AppColors.textSecondary,
          ),
          label: Text(
            'Reset',
            style: GoogleFonts.poppins(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCanvas() {
    return Consumer<EditorProvider>(
      builder: (context, provider, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: RepaintBoundary(
            key: _canvasKey,
            child: AspectRatio(
              aspectRatio: 1,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final size = Size(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: provider.gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: provider.gradientColors.first.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          // Text layer
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(
                                provider.editedText,
                                textAlign: provider.textAlign,
                                style: GoogleFonts.getFont(
                                  provider.selectedFont,
                                  fontSize: provider.fontSize,
                                  color: provider.textColor,
                                  fontWeight: provider.isBold
                                      ? FontWeight.bold
                                      : FontWeight.w600,
                                  fontStyle: provider.isItalic
                                      ? FontStyle.italic
                                      : FontStyle.normal,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),
                          // Sticker layers
                          ...List.generate(provider.stickers.length, (index) {
                            final sticker = provider.stickers[index];
                            final offset = provider.stickerOffsets[index];
                            return Positioned(
                              left: offset.dx,
                              top: offset.dy,
                              child: GestureDetector(
                                onPanUpdate: (details) {
                                  final newOffset = Offset(
                                    (offset.dx + details.delta.dx).clamp(
                                      0,
                                      size.width - 80,
                                    ),
                                    (offset.dy + details.delta.dy).clamp(
                                      0,
                                      size.height - 80,
                                    ),
                                  );
                                  provider.updateStickerOffset(
                                    index,
                                    newOffset,
                                  );
                                },
                                onLongPress: () => _confirmRemoveSticker(index),
                                child: SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: CachedNetworkImage(
                                    imageUrl: sticker.originalUrl,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _confirmRemoveSticker(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Remove sticker?',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<EditorProvider>().removeSticker(index);
              Navigator.pop(context);
            },
            child: Text(
              'Remove',
              style: GoogleFonts.poppins(color: AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Consumer<EditorProvider>(
      builder: (context, provider, _) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text editing row
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      maxLines: 2,
                      onChanged: provider.updateText,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type your status...',
                        hintStyle: GoogleFonts.poppins(
                          color: AppColors.textHint,
                          fontSize: 13,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.surfaceGrey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Bold / Italic / Align
                  Column(
                    children: [
                      _toolBtn(
                        icon: Icons.format_bold,
                        active: provider.isBold,
                        onTap: provider.toggleBold,
                      ),
                      const SizedBox(height: 4),
                      _toolBtn(
                        icon: Icons.format_italic,
                        active: provider.isItalic,
                        onTap: provider.toggleItalic,
                      ),
                    ],
                  ),
                  const SizedBox(width: 4),
                  Column(
                    children: [
                      _toolBtn(
                        icon: Icons.format_align_center,
                        active: provider.textAlign == TextAlign.center,
                        onTap: () => provider.updateTextAlign(TextAlign.center),
                      ),
                      const SizedBox(height: 4),
                      _toolBtn(
                        icon: Icons.format_align_left,
                        active: provider.textAlign == TextAlign.left,
                        onTap: () => provider.updateTextAlign(TextAlign.left),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Font size slider
              Row(
                children: [
                  const Icon(
                    Icons.text_fields,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppColors.primary,
                        thumbColor: AppColors.primary,
                        inactiveTrackColor: AppColors.surfaceGrey,
                        trackHeight: 3,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 7,
                        ),
                        overlayShape: SliderComponentShape.noOverlay,
                      ),
                      child: Slider(
                        value: provider.fontSize,
                        min: 12,
                        max: 48,
                        onChanged: provider.updateFontSize,
                      ),
                    ),
                  ),
                  Text(
                    '${provider.fontSize.toInt()}px',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Font picker
              SizedBox(
                height: 34,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: AppFonts.statusFonts.length,
                  itemBuilder: (context, index) {
                    final font = AppFonts.statusFonts[index];
                    final isSelected = provider.selectedFont == font;
                    return GestureDetector(
                      onTap: () => provider.updateFont(font),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.surfaceGrey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          font,
                          style: GoogleFonts.getFont(
                            font,
                            fontSize: 12,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),

              // Gradient picker
              SizedBox(
                height: 34,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: AppColors.allGradients.length,
                  itemBuilder: (context, index) {
                    final gradient = AppColors.allGradients[index];
                    final isSelected =
                        provider.gradientColors[0] == gradient[0];
                    return GestureDetector(
                      onTap: () => provider.updateGradient(gradient),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: gradient),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.textPrimary
                                : Colors.transparent,
                            width: 2.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: gradient.first.withOpacity(0.4),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  final provider = context.read<EditorProvider>();
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => GiphyPickerSheet(
                      onSelected: (sticker) {
                        final box =
                            _canvasKey.currentContext?.findRenderObject()
                                as RenderBox?;
                        final size = box?.size ?? const Size(300, 300);
                        provider.addSticker(sticker, size);
                      },
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceGrey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('😄', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(
                        'Add Sticker',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Text color picker
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Text:',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ...[
                    Colors.white,
                    Colors.black,
                    const Color(0xFFFFE066),
                    const Color(0xFFFF6584),
                    const Color(0xFF43D98C),
                  ].map(
                    (color) => GestureDetector(
                      onTap: () => provider.updateTextColor(color),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: provider.textColor == color
                                ? AppColors.primary
                                : Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _toolBtn({
    required IconData icon,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.surfaceGrey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 16,
          color: active ? Colors.white : AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _isSaving ? null : _saveToGallery,
              icon: _isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    )
                  : const Icon(
                      Icons.download,
                      size: 18,
                      color: AppColors.primary,
                    ),
              label: Text(
                _isSaving ? 'Saving...' : 'Save',
                style: GoogleFonts.poppins(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: _shareStatus,
              icon: const Icon(Icons.share, size: 18, color: Colors.white),
              label: Text(
                'Share Status',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 4,
                shadowColor: AppColors.primary.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
