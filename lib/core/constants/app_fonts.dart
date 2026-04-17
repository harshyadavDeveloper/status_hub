import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  static TextStyle heading1(Color color) => GoogleFonts.poppins(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: color,
  );

  static TextStyle heading2(Color color) => GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: color,
  );

  static TextStyle body(Color color) => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: color,
  );

  static TextStyle caption(Color color) => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: color,
  );

  static TextStyle button(Color color) => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: color,
  );

  // Font families for status text
  static const List<String> statusFonts = [
    'Poppins',
    'Lobster',
    'Pacifico',
    'Dancing Script',
    'Abril Fatface',
    'Righteous',
  ];
}
