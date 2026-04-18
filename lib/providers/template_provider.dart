import 'package:flutter/material.dart';
import '../models/template_model.dart';
import '../data/dummy_templates.dart';
import '../data/remote_config_service.dart';

class TemplateProvider extends ChangeNotifier {
  List<TemplateModel> _allTemplates = List.from(dummyTemplates);
  List<TrendingSection> _trendingSections = [];
  String _selectedCategory = 'All';
  String _selectedLanguage = 'All';
  bool _trendingLoaded = false;

  String get selectedCategory => _selectedCategory;
  String get selectedLanguage => _selectedLanguage;
  List<TrendingSection> get trendingSections => _trendingSections;
  bool get trendingLoaded => _trendingLoaded;

  List<TemplateModel> get filteredTemplates {
    return _allTemplates.where((t) {
      final categoryMatch =
          _selectedCategory == 'All' || t.category == _selectedCategory;
      final languageMatch =
          _selectedLanguage == 'All' || t.language == _selectedLanguage;
      return categoryMatch && languageMatch;
    }).toList();
  }

  List<TemplateModel> get favoriteTemplates =>
      _allTemplates.where((t) => t.isFavorite).toList();

  Future<void> loadTrending() async {
    _trendingSections = await RemoteConfigService.getTrendingSections();
    _trendingLoaded = true;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setLanguage(String language) {
    _selectedLanguage = language;
    notifyListeners();
  }

  void toggleFavorite(String id) {
    final index = _allTemplates.indexWhere((t) => t.id == id);
    if (index != -1) {
      _allTemplates[index].isFavorite = !_allTemplates[index].isFavorite;
      notifyListeners();
    }
  }
}