import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../data/festival_calendar.dart';
import '../providers/template_provider.dart';
import '../providers/editor_provider.dart';
import '../screens/editor/editor_screen.dart';

class FestivalBanner extends StatelessWidget {
  const FestivalBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final upcoming = upcomingFestivals;
    if (upcoming.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Next up — hero banner
        _buildHeroBanner(context, upcoming.first),
        // More upcoming — horizontal strip
        if (upcoming.length > 1)
          _buildUpcomingStrip(context, upcoming.skip(1).toList()),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildHeroBanner(BuildContext context, FestivalEvent event) {
    return GestureDetector(
      onTap: () => _openFestivalTemplates(context, event),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [event.color, event.color.withValues(alpha:0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: event.color.withValues(alpha:0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background emoji watermark
            Positioned(
              right: -10,
              top: -10,
              child: Text(event.emoji, style: const TextStyle(fontSize: 80)),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha:0.25),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            event.isToday
                                ? '🎉 Today!'
                                : event.daysUntil == 1
                                ? '⏰ Tomorrow!'
                                : '📅 In ${event.daysUntil} days',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          event.name,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // CTA button
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Make Status',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: event.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingStrip(BuildContext context, List<FestivalEvent> events) {
    return SizedBox(
      height: 72,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return GestureDetector(
            onTap: () => _openFestivalTemplates(context, event),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: event.color.withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: event.color.withValues(alpha:0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(event.emoji, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        event.name,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        event.isToday
                            ? 'Today! 🎉'
                            : event.daysUntil == 1
                            ? 'Tomorrow!'
                            : 'In ${event.daysUntil} days',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: event.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _openFestivalTemplates(BuildContext context, FestivalEvent event) {
    final provider = context.read<TemplateProvider>();

    // Find matching trending section
    final sections = provider.trendingSections;
    final match = sections.where((s) => s.id == event.trendingSectionId);

    if (match.isNotEmpty && match.first.templates.isNotEmpty) {
      // Open first template directly in editor
      context.read<EditorProvider>().loadTemplate(match.first.templates.first);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const EditorScreen()),
      );
    } else {
      // Show bottom sheet with message
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) => _FestivalComingSoonSheet(event: event),
      );
    }
  }
}

class _FestivalComingSoonSheet extends StatelessWidget {
  final FestivalEvent event;
  const _FestivalComingSoonSheet({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textHint,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(event.emoji, style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 12),
          Text(
            event.name,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Templates coming soon!\nCheck back closer to the festival.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: event.color,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Got it',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
