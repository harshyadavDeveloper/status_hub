import 'package:flutter/material.dart';

class AppColors {
  // Primary
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF9C95FF);
  static const Color primaryDark = Color(0xFF4B44CC);

  // Background
  static const Color background = Color(0xFFF8F9FE);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceGrey = Color(0xFFF2F3F7);

  // Text
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFFB0B7C3);

  // Accent
  static const Color accent = Color(0xFFFF6584);
  static const Color success = Color(0xFF43D98C);

  // Gradients
  static const List<Color> purpleGradient = [Color(0xFF6C63FF), Color(0xFF9C95FF)];
  static const List<Color> sunsetGradient = [Color(0xFFFF6584), Color(0xFFFFB347)];
  static const List<Color> oceanGradient = [Color(0xFF43D98C), Color(0xFF0ED2F7)];
  static const List<Color> nightGradient = [Color(0xFF1A1A2E), Color(0xFF16213E)];
  static const List<Color> roseGradient = [Color(0xFFf093fb), Color(0xFFf5576c)];
  static const List<Color> goldGradient = [Color(0xFFf7971e), Color(0xFFffd200)];

  static const List<List<Color>> allGradients = [
    purpleGradient,
    sunsetGradient,
    oceanGradient,
    nightGradient,
    roseGradient,
    goldGradient,
  ];
}