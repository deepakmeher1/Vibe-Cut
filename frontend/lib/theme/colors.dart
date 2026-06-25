import 'package:flutter/color_撥/material.dart'; // Wait, let's use standard import
import 'package:flutter/material.dart';

class VibeCutColors {
  // Light backgrounds (CapCut Light Mode style)
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF4F5F8); // Very light grey for text fields / buttons
  static const Color card = Color(0xFFFFFFFF);
  
  // Accent colors
  static const Color primary = Color(0xFF00C5FF); // Cyan/Blue matching CapCut '+ Create' button
  static const Color secondary = Color(0xFF7F00FF); // Purple Accent
  static const Color accent = Color(0xFFFF007F); // Pink Accent
  
  // Text colors
  static const Color textPrimary = Color(0xFF111111); // Black
  static const Color textSecondary = Color(0xFF7C7C82); // Gray
  static const Color textMuted = Color(0xFFE5E5EA); // Light Gray Divider/Border
  
  // State colors
  static const Color error = Color(0xFFFF3B30);
  static const Color success = Color(0xFF34C759);
  static const Color warning = Color(0xFFFF9500);
  
  // Gradients matching Screenshot 3 blue/cyan button
  static const Gradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00F2FE), Color(0xFF4FACFE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const Gradient neonGradient = LinearGradient(
    colors: [primary, Color(0xFF0080FF)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
