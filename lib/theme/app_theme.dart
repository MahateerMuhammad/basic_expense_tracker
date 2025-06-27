//ignore_for_file: const_types_in_flutter_widgets, unused_local_variable, unused_import, unused_field, deprecated_member_use
import 'package:flutter/material.dart';

class AppTheme {
  // Financial-themed color palette
  static const Color primaryGreen = Color(0xFF2E8B57); // Sea green for money/growth
  static const Color accentTeal = Color(0xFF20B2AA); // Light sea green
  static const Color expenseRed = Color(0xFFE74C3C); // Alert red for high expenses
  static const Color incomeGreen = Color(0xFF27AE60); // Success green
  static const Color warningAmber = Color(0xFFE67E22); // Warning amber
  static const Color backgroundGray = Color(0xFFF8F9FA); // Soft gray background
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF2C3E50);
  static const Color textLight = Color(0xFF7F8C8D);
  static const Color borderGray = Color(0xFFE5E7EB);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        brightness: Brightness.light,
        primary: primaryGreen,
        secondary: accentTeal,
        surface: cardWhite,
        background: backgroundGray,
        error: expenseRed,
      ),
      scaffoldBackgroundColor: backgroundGray,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryGreen,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: cardWhite,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: borderGray, width: 1),
        ),
        shadowColor: Colors.black12,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: TextStyle(color: textLight),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: textDark,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: textDark,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: textDark,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          color: textLight,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
      iconTheme: IconThemeData(
        color: primaryGreen,
        size: 24,
      ),
    );
  }

  // Category colors for expense visualization
  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return const Color(0xFFFF6B6B);
      case 'transport':
        return const Color(0xFF4ECDC4);
      case 'entertainment':
        return const Color(0xFFFFE66D);
      case 'other':
        return const Color(0xFF95A5A6);
      default:
        return const Color(0xFF95A5A6);
    }
  }

  // Expense amount styling based on value
  static Color getAmountColor(double amount) {
    if (amount > 5000) return expenseRed;
    if (amount > 2000) return warningAmber;
    return incomeGreen;
  }
}