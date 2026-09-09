import 'package:flutter/material.dart';

class TileColors {
  final Color correct;
  final Color present;
  final Color absent;
  final Color emptyBorder;

  const TileColors({
    required this.correct,
    required this.present,
    required this.absent,
    required this.emptyBorder,
  });

  // New palette
  static const classic = TileColors(
    correct: Color(0xFFC6F1E6),   // correct letter
    present: Color(0xFFFFF0C7),   // correct letter, wrong placement
    absent: Color(0xFFD4D4D4),    // wrong letter
    emptyBorder: Color(0xFFD4D4D4),
  );

  // Colorblind palette kept distinct from classic on purpose
  static const colorblind = TileColors(
    correct: Color(0xFFE8820C),
    present: Color(0xFF3B82F6),
    absent: Color(0xFFD4D4D4),
    emptyBorder: Color(0xFFD4D4D4),
  );
}

/// Colors specifically for the on-screen keyboard's unused-key state.
class KeyboardColors {
  static const background = Color(0xFFFFF5FB);
  static const keyA = Color(0xFFF6D6F2); // alternate 1
  static const keyB = Color(0xFFD8D7FF); // alternate 2
  static const border = Color(0xFFD4D4D4);
  static const textColor = Color(0xFF4A4458); // dark plum, readable on pastels
}

class AppTheme {
  static ThemeData light() => ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        scaffoldBackgroundColor: KeyboardColors.background,
        colorSchemeSeed: const Color(0xFFD8D7FF),
      );

  static ThemeData dark() => ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFFC6F1E6),
        scaffoldBackgroundColor: const Color(0xFF121213),
      );
}