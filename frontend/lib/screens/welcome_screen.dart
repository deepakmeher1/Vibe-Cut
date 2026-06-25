import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: VibeCutColors.background,
        ),
        child: Stack(
          children: [
            // Background ambient glow circles
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: VibeCutColors.primary.withOpacity(0.15),
                  blurRadius: 100,
                ),
              ),
            ),
            Positioned(
              bottom: -150,
              left: -100,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: VibeCutColors.secondary.withOpacity(0.15),
                  blurRadius: 120,
                ),
              ),
            ),
            
            // Core UI Content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    
                    // Brand Icon & Logo
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: VibeCutColors.primaryGradient,
                          boxShadow: [
                            BoxShadow(
                              color: VibeCutColors.primary.withOpacity(0.4),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            )
                          ],
                        ),
                        child: const Icon(
                          Icons.movie_creation_outlined,
                          size: 64,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // App Name
                    Center(
                      child: ShaderMask(
                        shaderCallback: (bounds) => VibeCutColors.neonGradient.createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                        child: Text(
                          'VibeCut',
                          style: GoogleFonts.outfit(
                            fontSize: 48,
                            fontWeight: FontWeight.extrabold,
                            color: Colors.white,
                            letterSpacing: -1,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Subtitle
                    Text(
                      'Elevate your edits, define your vibe.\nPremium cross-platform video editor.',
                      textAlign: Center,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        color: VibeCutColors.textSecondary,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Create New Project Trigger
                    ElevatedButton(
                      onPressed: () {
                        // Redirect to login/signup for new projects (base version requirement)
                        Navigator.pushNamed(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ).copyWith(
                        elevation: ButtonStyleButton.allOrNull(0),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: VibeCutColors.primaryGradient,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: VibeCutColors.primary.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            )
                          ]
                        ),
                        child: Container(
                          constraints: const BoxConstraints(minHeight: 56),
                          alignment: Alignment.center,
                          child: Text(
                            'Start Creating',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Inline Options: Login & Register
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: GoogleFonts.outfit(
                            color: VibeCutColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: Text(
                            'Log In',
                            style: GoogleFonts.outfit(
                              color: VibeCutColors.secondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
