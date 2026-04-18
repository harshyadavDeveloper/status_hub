import 'package:flutter/material.dart';

class FestivalEvent {
  final String id;
  final String name;
  final String emoji;
  final DateTime date;
  final Color color;
  final String trendingSectionId; // links to remote config section

  const FestivalEvent({
    required this.id,
    required this.name,
    required this.emoji,
    required this.date,
    required this.color,
    required this.trendingSectionId,
  });

  int get daysUntil => date.difference(DateTime.now()).inDays;
  bool get isToday => daysUntil == 0;
  bool get isPast => daysUntil < 0;
  bool get isUpcoming => daysUntil > 0 && daysUntil <= 30;
}

final List<FestivalEvent> festivalCalendar2026 = [
  FestivalEvent(
    id: 'ipl',
    name: 'IPL 2026',
    emoji: '🏏',
    date: DateTime(2026, 4, 1),
    color: const Color(0xFFf7971e),
    trendingSectionId: 'ipl_2026',
  ),
  FestivalEvent(
    id: 'eid',
    name: 'Eid Mubarak',
    emoji: '🌙',
    date: DateTime(2026, 3, 30),
    color: const Color(0xFF43D98C),
    trendingSectionId: 'eid_2026',
  ),
  FestivalEvent(
    id: 'mothers_day',
    name: "Mother's Day",
    emoji: '💐',
    date: DateTime(2026, 5, 10),
    color: const Color(0xFFf093fb),
    trendingSectionId: 'mothers_day_2026',
  ),
  FestivalEvent(
    id: 'buddha_purnima',
    name: 'Buddha Purnima',
    emoji: '🪷',
    date: DateTime(2026, 5, 23),
    color: const Color(0xFFf7971e),
    trendingSectionId: 'buddha_purnima_2026',
  ),
  FestivalEvent(
    id: 'friendship_day',
    name: 'Friendship Day',
    emoji: '👫',
    date: DateTime(2026, 8, 2),
    color: const Color(0xFF6C63FF),
    trendingSectionId: 'friendship_day_2026',
  ),
  FestivalEvent(
    id: 'independence_day',
    name: 'Independence Day',
    emoji: '🇮🇳',
    date: DateTime(2026, 8, 15),
    color: const Color(0xFFFF6584),
    trendingSectionId: 'independence_day_2026',
  ),
  FestivalEvent(
    id: 'raksha_bandhan',
    name: 'Raksha Bandhan',
    emoji: '🪢',
    date: DateTime(2026, 8, 28),
    color: const Color(0xFFf093fb),
    trendingSectionId: 'raksha_bandhan_2026',
  ),
  FestivalEvent(
    id: 'ganesh_chaturthi',
    name: 'Ganesh Chaturthi',
    emoji: '🐘',
    date: DateTime(2026, 9, 11),
    color: const Color(0xFFf7971e),
    trendingSectionId: 'ganesh_chaturthi_2026',
  ),
  FestivalEvent(
    id: 'navratri',
    name: 'Navratri',
    emoji: '🪔',
    date: DateTime(2026, 10, 9),
    color: const Color(0xFFf093fb),
    trendingSectionId: 'navratri_2026',
  ),
  FestivalEvent(
    id: 'dussehra',
    name: 'Dussehra',
    emoji: '🏹',
    date: DateTime(2026, 10, 19),
    color: const Color(0xFFFF6584),
    trendingSectionId: 'dussehra_2026',
  ),
  FestivalEvent(
    id: 'diwali',
    name: 'Diwali',
    emoji: '🪔',
    date: DateTime(2026, 11, 8),
    color: const Color(0xFFf7971e),
    trendingSectionId: 'diwali_2026',
  ),
  FestivalEvent(
    id: 'christmas',
    name: 'Christmas',
    emoji: '🎄',
    date: DateTime(2026, 12, 25),
    color: const Color(0xFF43D98C),
    trendingSectionId: 'christmas_2026',
  ),
  FestivalEvent(
    id: 'new_year',
    name: 'New Year 2027',
    emoji: '🎆',
    date: DateTime(2027, 1, 1),
    color: const Color(0xFF6C63FF),
    trendingSectionId: 'new_year_2027',
  ),
];

// Returns events happening within next 30 days, sorted by date
List<FestivalEvent> get upcomingFestivals {
  final now = DateTime.now();
  return festivalCalendar2026.where((e) {
    final diff = e.date.difference(now).inDays;
    return diff >= -1 && diff <= 30;
  }).toList()..sort((a, b) => a.date.compareTo(b.date));
}

// Returns the single next upcoming festival
FestivalEvent? get nextFestival {
  final upcoming = upcomingFestivals;
  return upcoming.isEmpty ? null : upcoming.first;
}
