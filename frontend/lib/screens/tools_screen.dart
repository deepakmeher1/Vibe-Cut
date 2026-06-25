import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VibeCutColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'All tools',
          style: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 100.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Quick Actions Section
                _buildSectionHeader('Quick actions'),
                const SizedBox(height: 12),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                  children: [
                    _buildToolItem(Icons.face_retouching_natural_outlined, 'Retouch'),
                    _buildToolItem(Icons.closed_caption_outlined, 'Auto captions'),
                    _buildToolItem(Icons.speaker_notes_outlined, 'Teleprompter'),
                    _buildToolItem(Icons.camera_alt_outlined, 'Camera'),
                    _buildToolItem(Icons.speed_outlined, 'Adjust speed'),
                    _buildToolItem(Icons.mic_none_outlined, 'Record'),
                    _buildToolItem(Icons.grid_on_outlined, 'Collage'),
                    _buildToolItem(Icons.screenshot_outlined, 'Frame capture'),
                    _buildToolItem(Icons.desktop_windows_outlined, 'Desktop editor', isPro: true),
                  ],
                ),
                const SizedBox(height: 32),

                // 2. AI Tools Section
                _buildSectionHeader('AI tools'),
                const SizedBox(height: 12),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                  children: [
                    _buildToolItem(Icons.auto_awesome_outlined, 'AutoCut'),
                  ],
                ),
                const SizedBox(height: 32),

                // 3. Photo Editing Section
                _buildSectionHeader('Photo editing'),
                const SizedBox(height: 12),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                  children: [
                    _buildToolItem(Icons.portrait_outlined, 'Remove background'),
                    _buildToolItem(Icons.aspect_ratio_outlined, 'AI expand'),
                    _buildToolItem(Icons.text_fields_outlined, 'Text to image'),
                  ],
                ),
              ],
            ),
          ),
          
          // 4. Floating bottom gradient button "+ New project"
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, color: Colors.white, size: 24),
              label: Text(
                'New project',
                style: GoogleFonts.outfit(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
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
                  gradient: VibeCutColors.neonGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: VibeCutColors.primary.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 56),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add, color: Colors.white, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'New project',
                        style: GoogleFonts.outfit(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 17,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildToolItem(IconData icon, String label, {bool isPro = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Icon box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: VibeCutColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: VibeCutColors.textMuted.withOpacity(0.15), width: 1),
              ),
              child: Icon(icon, size: 26, color: Colors.white),
            ),
            
            // Pro/Free Badge
            if (isPro)
              Positioned(
                top: -6,
                right: -6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    gradient: VibeCutColors.primaryGradient,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'PRO',
                    style: TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: 11,
            color: VibeCutColors.textSecondary,
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
