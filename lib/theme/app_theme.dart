import 'package:flutter/material.dart';

const String fontFamily = 'roboto';

class AppColors {
  // Primary
  static const Color primary = Color(0xFF2F6FED);

  // Backgrounds
  static const Color scaffoldBackground = Color(0xFFF7F9FC);
  static const Color card = Colors.white;

  // Text
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const List<Color> categoryColors = [ Colors.deepOrangeAccent,Colors.deepPurpleAccent, Colors.green, Colors.redAccent, ];


  // Other
  static const Color border = Color(0xFFE5E7EB);
  static const MaterialColor primarySwatch =
      MaterialColor(0xFF2F6FED, <int, Color>{
        50: Color(0xFFE8EFFF),
        100: Color(0xFFC5D6FF),
        200: Color(0xFF9BB8FF),
        300: Color(0xFF7099FF),
        400: Color(0xFF4F82FF),
        500: Color(0xFF2F6FED),
        600: Color(0xFF2A63D6),
        700: Color(0xFF2357BE),
        800: Color(0xFF1D4CA6),
        900: Color(0xFF123785),
      });
}

class AppTextStyles {
  static const TextStyle headline = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle title = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const TextStyle titleWhite = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle small = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
  static const TextStyle smallWhite = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.white70,
  );
  static const TextStyle secondary = TextStyle(
    color: AppColors.primary,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
 
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primarySwatch: AppColors.primarySwatch,

    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.scaffoldBackground,
    fontFamily: 'Poppins',

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue.shade900,
      foregroundColor: Colors.white,
      // elevation: 8,
      centerTitle: true,
    ),

    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14),
        textStyle: AppTextStyles.button,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      prefixIconColor: AppColors.textSecondary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
