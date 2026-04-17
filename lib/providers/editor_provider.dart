import 'package:flutter/material.dart';
import '../models/template_model.dart';

class EditorProvider extends ChangeNotifier {
  TemplateModel? _currentTemplate;
  String _editedText = '';
  String _selectedFont = 'Poppins';
  double _fontSize = 24.0;
  Color _textColor = Colors.white;
  List<Color> _gradientColors = [const Color(0xFF6C63FF), const Color(0xFF9C95FF)];
  TextAlign _textAlign = TextAlign.center;
  bool _isBold = false;
  bool _isItalic = false;

  // Getters
  TemplateModel? get currentTemplate => _currentTemplate;
  String get editedText => _editedText;
  String get selectedFont => _selectedFont;
  double get fontSize => _fontSize;
  Color get textColor => _textColor;
  List<Color> get gradientColors => _gradientColors;
  TextAlign get textAlign => _textAlign;
  bool get isBold => _isBold;
  bool get isItalic => _isItalic;

  void loadTemplate(TemplateModel template) {
    _currentTemplate = template;
    _editedText = template.text;
    _selectedFont = template.fontFamily;
    _gradientColors = template.gradientColors
        .map((hex) => Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16)))
        .toList();
    _fontSize = 24.0;
    _textColor = Colors.white;
    _textAlign = TextAlign.center;
    _isBold = false;
    _isItalic = false;
    notifyListeners();
  }

  void updateText(String text) {
    _editedText = text;
    notifyListeners();
  }

  void updateFont(String font) {
    _selectedFont = font;
    notifyListeners();
  }

  void updateFontSize(double size) {
    _fontSize = size;
    notifyListeners();
  }

  void updateTextColor(Color color) {
    _textColor = color;
    notifyListeners();
  }

  void updateGradient(List<Color> colors) {
    _gradientColors = colors;
    notifyListeners();
  }

  void updateTextAlign(TextAlign align) {
    _textAlign = align;
    notifyListeners();
  }

  void toggleBold() {
    _isBold = !_isBold;
    notifyListeners();
  }

  void toggleItalic() {
    _isItalic = !_isItalic;
    notifyListeners();
  }

  void reset() {
    if (_currentTemplate != null) loadTemplate(_currentTemplate!);
  }
}