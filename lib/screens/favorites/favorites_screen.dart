import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/template_provider.dart';
import '../../providers/editor_provider.dart';
import '../../widgets/template_card.dart';
import '../editor/editor_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Favourites',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Consumer<TemplateProvider>(
        builder: (context, provider, _) {
          final favorites = provider.favoriteTemplates;

          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGrey,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      size: 48,
                      color: AppColors.textHint,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No favourites yet',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the ♥ on any template to save it here',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final template = favorites[index];
              return TemplateCard(
                template: template,
                onFavorite: () => provider.toggleFavorite(template.id),
                onTap: () {
                  context.read<EditorProvider>().loadTemplate(template);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditorScreen()),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
