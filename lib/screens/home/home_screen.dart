import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:status_hub/data/remote_config_service.dart';
import 'package:status_hub/main.dart';
import 'package:status_hub/widgets/ad_banner_placeholder.dart';
import 'package:status_hub/widgets/festival_banner.dart';
import '../../core/constants/app_colors.dart';
import '../../data/dummy_templates.dart';
import '../../providers/template_provider.dart';
import '../../providers/editor_provider.dart';
import '../../widgets/template_card.dart';
import '../editor/editor_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _messageIndex = 0;
  final List<String> _messages = [
    "Pick a vibe, share it 🔥",
    "Express your mood 💭",
    "Create stunning status ✨",
    "Make your story stand out 🚀",
  ];
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<TemplateProvider>().loadTrending());
    _startMessageRotation();
  }

  void _startMessageRotation() {
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;

      setState(() {
        _messageIndex = (_messageIndex + 1) % _messages.length;
      });

      _startMessageRotation(); // loop
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildLanguageFilter(),
              const AdBannerPlaceholder(),
              _buildCategoryFilter(),
              _buildFestivalBanner(),
              _buildTrendingSection(),
              _buildGrid(), // now part of scroll
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status Hub',
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.5),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Text(
                  _messages[_messageIndex],
                  key: ValueKey(_messages[_messageIndex]), // VERY IMPORTANT
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.favorite, color: AppColors.accent),
              onPressed: () {
                context.findAncestorStateOfType<MainShellState>()?.switchTab(1);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageFilter() {
    return Consumer<TemplateProvider>(
      builder: (context, provider, _) {
        return SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: languages.length,
            itemBuilder: (context, index) {
              final lang = languages[index];
              final isSelected = provider.selectedLanguage == lang;
              return GestureDetector(
                onTap: () => provider.setLanguage(lang),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha:0.3)
                            : Colors.black.withValues(alpha:0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    lang,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCategoryFilter() {
    return Consumer<TemplateProvider>(
      builder: (context, provider, _) {
        return SizedBox(
          height: 44,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isSelected = provider.selectedCategory == cat;
              return GestureDetector(
                onTap: () => provider.setCategory(cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.textPrimary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.textPrimary
                          : AppColors.textHint,
                    ),
                  ),
                  child: Text(
                    cat,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTrendingSection() {
    return Consumer<TemplateProvider>(
      builder: (context, provider, _) {
        if (!provider.trendingLoaded || provider.trendingSections.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Trending Now',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: provider.trendingSections.length,
                itemBuilder: (context, sectionIndex) {
                  final section = provider.trendingSections[sectionIndex];
                  return _buildTrendingCard(context, section);
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget _buildTrendingCard(BuildContext context, TrendingSection section) {
    if (section.templates.isEmpty) return const SizedBox.shrink();
    final template = section.templates.first;

    Color hexToColor(String hex) =>
        Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));

    final colors = template.gradientColors.map(hexToColor).toList();

    return GestureDetector(
      onTap: () {
        context.read<EditorProvider>().loadTemplate(template);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EditorScreen()),
        );
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.first.withValues(alpha:0.35),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  template.text,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha:0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    section.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return Consumer<TemplateProvider>(
      builder: (context, provider, _) {
        final templates = provider.filteredTemplates;
        if (templates.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(40),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.search_off,
                    size: 48,
                    color: AppColors.textHint,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No templates found',
                    style: GoogleFonts.poppins(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          );
        }
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: templates.length,
          itemBuilder: (context, index) {
            final template = templates[index];
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
    );
  }

  Widget _buildFestivalBanner() {
    return Consumer<TemplateProvider>(
      builder: (context, provider, _) {
        if (!provider.trendingLoaded) return const SizedBox.shrink();
        return const FestivalBanner();
      },
    );
  }
}
