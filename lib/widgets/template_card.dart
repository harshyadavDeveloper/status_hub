import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/template_model.dart';
import '../core/constants/app_colors.dart';

class TemplateCard extends StatelessWidget {
  final TemplateModel template;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const TemplateCard({
    super.key,
    required this.template,
    required this.onTap,
    required this.onFavorite,
  });

  Color _hexToColor(String hex) =>
      Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));

  @override
  Widget build(BuildContext context) {
    final colors = template.gradientColors.map(_hexToColor).toList();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.first.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Text
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  template.text,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(
                    template.fontFamily,
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            // Favorite button
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: onFavorite,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    template.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: template.isFavorite ? AppColors.accent : Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
            // Language tag
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  template.language,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}