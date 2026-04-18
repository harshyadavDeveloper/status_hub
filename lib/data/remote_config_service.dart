import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../models/template_model.dart';

class TrendingSection {
  final String id;
  final String title;
  final List<TemplateModel> templates;

  TrendingSection({
    required this.id,
    required this.title,
    required this.templates,
  });

  factory TrendingSection.fromJson(Map<String, dynamic> json) {
    final List templateList = json['templates'] ?? [];
    return TrendingSection(
      id: json['id'],
      title: json['title'],
      templates: templateList.map((t) => TemplateModel.fromMap(t)).toList(),
    );
  }
}

class RemoteConfigService {
  static final FirebaseRemoteConfig _remoteConfig =
      FirebaseRemoteConfig.instance;

  static Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    await _remoteConfig.setDefaults({
      'trending_templates': jsonEncode({
        'trending': [
          {
            'id': 't1',
            'title': 'Trending Now 🔥',
            'templates': [
              {
                'id': 'default1',
                'text': 'Good vibes only ✨',
                'gradientColors': ['#6C63FF', '#9C95FF'],
                'fontFamily': 'Pacifico',
                'category': 'Motivational',
                'language': 'English',
                'isFavorite': false,
              },
            ],
          },
        ],
      }),
    });

    try {
      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      // Falls back to defaults silently
    }
  }

  static Future<List<TrendingSection>> getTrendingSections() async {
    try {
      await _remoteConfig.fetchAndActivate();
    } catch (_) {}

    final raw = _remoteConfig.getString('trending_templates');
    if (raw.isEmpty) return [];

    try {
      final data = jsonDecode(raw);
      final List sections = data['trending'] ?? [];
      return sections.map((s) => TrendingSection.fromJson(s)).toList();
    } catch (e) {
      return [];
    }
  }
}
