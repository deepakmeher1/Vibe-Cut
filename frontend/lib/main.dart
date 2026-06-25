import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/colors.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/main_layout.dart';

void main() {
  runApp(const VibeCutApp());
}

class VibeCutApp extends StatelessWidget {
  const VibeCutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VibeCut',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: VibeCutColors.background,
        primaryColor: VibeCutColors.primary,
        hintColor: VibeCutColors.secondary,
        colorScheme: const ColorScheme.dark(
          primary: VibeCutColors.primary,
          secondary: VibeCutColors.secondary,
          surface: VibeCutColors.surface,
          error: VibeCutColors.error,
        ),
        textTheme: GoogleFonts.outfitTextTheme(
          ThemeData.dark().textTheme,
        ).apply(
          bodyColor: VibeCutColors.textPrimary,
          displayColor: VibeCutColors.textPrimary,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: VibeCutColors.surface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: VibeCutColors.textMuted, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: VibeCutColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: VibeCutColors.error, width: 1),
          ),
          labelStyle: GoogleFonts.outfit(color: VibeCutColors.textSecondary),
          hintStyle: GoogleFonts.outfit(color: VibeCutColors.textSecondary.withOpacity(0.6)),
        ),
      ),
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const MainLayout(),
      },
    );
  }
}
