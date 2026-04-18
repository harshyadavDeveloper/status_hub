import 'package:flutter/material.dart';
import 'package:status_hub/data/giphy_service.dart';
import '../models/template_model.dart';

class EditorProvider extends ChangeNotifier {
  TemplateModel? _currentTemplate;
  String _editedText = '';
  String _selectedFont = 'Poppins';
  double _fontSize = 24.0;
  Color _textColor = Colors.white;
  List<Color> _gradientColors = [
    const Color(0xFF6C63FF),
    const Color(0xFF9C95FF),
  ];
  TextAlign _textAlign = TextAlign.center;
  bool _isBold = false;
  bool _isItalic = false;

  List<GiphySticker> _stickers = [];
  List<Offset> _stickerOffsets = [];

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

  List<GiphySticker> get stickers => _stickers;
  List<Offset> get stickerOffsets => _stickerOffsets;

  void addSticker(GiphySticker sticker, Size canvasSize) {
    _stickers.add(sticker);
    _stickerOffsets.add(
      Offset(canvasSize.width / 2 - 40, canvasSize.height / 2 - 40),
    );
    notifyListeners();
  }

  void updateStickerOffset(int index, Offset offset) {
    if (index < _stickerOffsets.length) {
      _stickerOffsets[index] = offset;
      notifyListeners();
    }
  }

  void removeSticker(int index) {
    if (index < _stickers.length) {
      _stickers.removeAt(index);
      _stickerOffsets.removeAt(index);
      notifyListeners();
    }
  }

  // Add to reset():
  void reset() {
    if (_currentTemplate != null) loadTemplate(_currentTemplate!);
    _stickers = [];
    _stickerOffsets = [];
    notifyListeners();
  }

  void loadTemplate(TemplateModel template) {
    _currentTemplate = template;
    _editedText = template.text;
    _selectedFont = template.fontFamily;
    _gradientColors = template.gradientColors
        .map(
          (hex) => Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16)),
        )
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
}
