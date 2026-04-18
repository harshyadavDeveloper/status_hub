import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:saver_gallery/saver_gallery.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_fonts.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final GlobalKey _canvasKey = GlobalKey();
  final TextEditingController _textController = TextEditingController(
    text: 'Your vibe here ✨',
  );

  String _selectedFont = 'Poppins';
  double _fontSize = 24.0;
  Color _textColor = Colors.white;
  TextAlign _textAlign = TextAlign.center;
  bool _isBold = false;
  bool _isItalic = false;
  bool _isSaving = false;
  List<Color> _gradientColors = AppColors.purpleGradient;

  final List<Color> _textColors = [
    Colors.white,
    Colors.black,
    const Color(0xFFFFE066),
    const Color(0xFFFF6584),
    const Color(0xFF43D98C),
    const Color(0xFF0ED2F7),
  ];

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
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [_buildCanvas(), _buildToolbar(), _buildBottomActions()],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      
      title: Text(
        'Create Status',
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => setState(() {
            _textController.text = 'Your vibe here ✨';
            _selectedFont = 'Poppins';
            _fontSize = 24.0;
            _textColor = Colors.white;
            _gradientColors = AppColors.purpleGradient;
            _isBold = false;
            _isItalic = false;
            _textAlign = TextAlign.center;
          }),
          child: Text(
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: RepaintBoundary(
        key: _canvasKey,
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: _gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: _gradientColors.first.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  _textController.text.isEmpty
                      ? 'Start typing...'
                      : _textController.text,
                  textAlign: _textAlign,
                  style: GoogleFonts.getFont(
                    _selectedFont,
                    fontSize: _fontSize,
                    color: _textColor,
                    fontWeight: _isBold ? FontWeight.bold : FontWeight.w600,
                    fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToolbar() {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
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
              // Text input + format buttons
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      maxLines: 3,
                      onChanged: (_) => setState(() {}),
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
                  Column(
                    children: [
                      _toolBtn(
                        icon: Icons.format_bold,
                        active: _isBold,
                        onTap: () => setState(() => _isBold = !_isBold),
                      ),
                      const SizedBox(height: 4),
                      _toolBtn(
                        icon: Icons.format_italic,
                        active: _isItalic,
                        onTap: () => setState(() => _isItalic = !_isItalic),
                      ),
                    ],
                  ),
                  const SizedBox(width: 4),
                  Column(
                    children: [
                      _toolBtn(
                        icon: Icons.format_align_center,
                        active: _textAlign == TextAlign.center,
                        onTap: () =>
                            setState(() => _textAlign = TextAlign.center),
                      ),
                      const SizedBox(height: 4),
                      _toolBtn(
                        icon: Icons.format_align_left,
                        active: _textAlign == TextAlign.left,
                        onTap: () =>
                            setState(() => _textAlign = TextAlign.left),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Font size
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
                        value: _fontSize,
                        min: 12,
                        max: 48,
                        onChanged: (v) => setState(() => _fontSize = v),
                      ),
                    ),
                  ),
                  Text(
                    '${_fontSize.toInt()}px',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Font picker
              _sectionLabel('Font'),
              const SizedBox(height: 6),
              SizedBox(
                height: 34,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: AppFonts.statusFonts.length,
                  itemBuilder: (context, index) {
                    final font = AppFonts.statusFonts[index];
                    final isSelected = _selectedFont == font;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedFont = font),
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
              const SizedBox(height: 12),

              // Gradient picker
              _sectionLabel('Background'),
              const SizedBox(height: 6),
              SizedBox(
                height: 34,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: AppColors.allGradients.length,
                  itemBuilder: (context, index) {
                    final gradient = AppColors.allGradients[index];
                    final isSelected = _gradientColors.first == gradient.first;
                    return GestureDetector(
                      onTap: () => setState(() => _gradientColors = gradient),
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
              const SizedBox(height: 12),

              // Text color picker
              _sectionLabel('Text Color'),
              const SizedBox(height: 6),
              Row(
                children: _textColors
                    .map(
                      (color) => GestureDetector(
                        onTap: () => setState(() => _textColor = color),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 10),
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _textColor == color
                                  ? AppColors.primary
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) => Text(
    label,
    style: GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.textSecondary,
    ),
  );

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
