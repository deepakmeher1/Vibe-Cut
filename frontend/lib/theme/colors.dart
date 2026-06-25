import 'package:flutter/material.dart';

class VibeCutColors {
  // Deep dark backgrounds
  static const Color background = Color(0xFF0C0C0E);
  static const Color surface = Color(0xFF16161A);
  static const Color card = Color(0xFF1E1E24);
  
  // High-contrast primary neon colors
  static const Color primary = Color(0xFF8A2BE2); // Electric Purple
  static const Color secondary = Color(0xFF00E5FF); // Neon Cyan
  static const Color accent = Color(0xFFFF007F); // Neon Pink
  
  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8A8A93);
  static const Color textMuted = Color(0xFF4E4E54);
  
  // State colors
  static const Color error = Color(0xFFFF3B30);
  static const Color success = Color(0xFF34C759);
  static const Color warning = Color(0xFFFF9500);
  
  // Gradients for premium UI looks
  static const Gradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF4A00E0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const Gradient neonGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const Gradient darkGlassGradient = LinearGradient(
    colors: [Color(0x1AFFFFFF), Color(0x08FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
