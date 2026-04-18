import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/app_string.dart';

class GiphySticker {
  final String id;
  final String previewUrl;
  final String originalUrl;
  final double width;
  final double height;

  GiphySticker({
    required this.id,
    required this.previewUrl,
    required this.originalUrl,
    required this.width,
    required this.height,
  });

  factory GiphySticker.fromJson(Map<String, dynamic> json) {
    final images = json['images'];
    final preview = images['fixed_width_small'];
    final original = images['original'];
    return GiphySticker(
      id: json['id'],
      previewUrl: preview['url'],
      originalUrl: original['url'],
      width: double.tryParse(original['width'].toString()) ?? 200,
      height: double.tryParse(original['height'].toString()) ?? 200,
    );
  }
}

class GiphyService {
  static Future<List<GiphySticker>> fetchTrending({int limit = 24}) async {
    try {
      final uri = Uri.parse(
        '${AppStrings.giphyBaseUrl}/stickers/trending'
        '?api_key=${AppStrings.giphyApiKey}'
        '&limit=$limit'
        '&rating=g',
      );
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List list = data['data'];
        return list.map((e) => GiphySticker.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<List<GiphySticker>> searchStickers(String query, {int limit = 24}) async {
    try {
      final uri = Uri.parse(
        '${AppStrings.giphyBaseUrl}/stickers/search'
        '?api_key=${AppStrings.giphyApiKey}'
        '&q=${Uri.encodeComponent(query)}'
        '&limit=$limit'
        '&rating=g',
      );
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List list = data['data'];
        return list.map((e) => GiphySticker.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}