import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_colors.dart';
import '../data/giphy_service.dart';

class GiphyPickerSheet extends StatefulWidget {
  final Function(GiphySticker) onSelected;

  const GiphyPickerSheet({super.key, required this.onSelected});

  @override
  State<GiphyPickerSheet> createState() => _GiphyPickerSheetState();
}

class _GiphyPickerSheetState extends State<GiphyPickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<GiphySticker> _stickers = [];
  bool _isLoading = true;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadTrending();
  }

  Future<void> _loadTrending() async {
    setState(() => _isLoading = true);
    final stickers = await GiphyService.fetchTrending();
    if (mounted)
      setState(() {
        _stickers = stickers;
        _isLoading = false;
      });
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) {
      _loadTrending();
      return;
    }
    setState(() => _isSearching = true);
    final stickers = await GiphyService.searchStickers(query);
    if (mounted)
      setState(() {
        _stickers = stickers;
        _isSearching = false;
      });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          _buildHandle(),
          _buildHeader(),
          _buildSearchBar(),
          _buildGrid(),
          _buildGiphyBadge(),
        ],
      ),
    );
  }

  Widget _buildHandle() => Container(
    margin: const EdgeInsets.only(top: 12),
    width: 36,
    height: 4,
    decoration: BoxDecoration(
      color: AppColors.textHint,
      borderRadius: BorderRadius.circular(2),
    ),
  );

  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Add Sticker',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: AppColors.textSecondary),
        ),
      ],
    ),
  );

  Widget _buildSearchBar() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: TextField(
      controller: _searchController,
      onSubmitted: _search,
      onChanged: (v) {
        if (v.isEmpty) _loadTrending();
      },
      style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: 'Search stickers...',
        hintStyle: GoogleFonts.poppins(color: AppColors.textHint, fontSize: 13),
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.textHint,
          size: 20,
        ),
        suffixIcon: _isSearching
            ? const Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              )
            : null,
        filled: true,
        fillColor: AppColors.surfaceGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    ),
  );

  Widget _buildGrid() {
    if (_isLoading) {
      return const Expanded(
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_stickers.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off, size: 40, color: AppColors.textHint),
              const SizedBox(height: 8),
              Text(
                'No stickers found',
                style: GoogleFonts.poppins(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: _stickers.length,
        itemBuilder: (context, index) {
          final sticker = _stickers[index];
          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
              widget.onSelected(sticker);
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: sticker.previewUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.broken_image_outlined,
                    color: AppColors.textHint,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGiphyBadge() => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      'Powered by GIPHY',
      style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textHint),
    ),
  );
}
