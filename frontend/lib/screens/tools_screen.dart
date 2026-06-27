import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';
import '../widgets/media_picker_dialog.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  void _showMockTeleprompter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Teleprompter Mode',
                        style: GoogleFonts.outfit(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Text(
                          "Welcome to VibeCut Teleprompter. Speak naturally as these words scroll past the screen. You can customize font size, scrolling speed, and edit your speech text using the control buttons below.\n\n"
                          "VibeCut makes creating short videos, tutorials, and speeches extremely simple with AI-guided tools, transitions, and automatic overlays.\n\n"
                          "Customize your presentation, align the camera focus, and hit start record to begin.",
                          style: GoogleFonts.outfit(color: VibeCutColors.primary, fontSize: 22, height: 1.6, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.text_fields, color: Colors.white, size: 28),
                        onPressed: () {},
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Starting Teleprompter Capture...'), backgroundColor: VibeCutColors.success),
                          );
                        },
                        icon: const Icon(Icons.play_arrow, color: Colors.black),
                        label: const Text('Start Recording'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: VibeCutColors.primary,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings, color: Colors.white, size: 28),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _handleAutoCut(BuildContext context) async {
    final selected = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const MediaPickerDialog(),
    );
    if (selected != null) {
      final name = selected['name'] ?? 'Media';
      final img = selected['img'] ?? '';
      
      // Auto-assemble a template config
      final template = {
        'title': 'AutoCut $name',
        'thumbnail_url': img,
        'duration': '00:10',
        'size': '4 MB',
        'timeline_data': '{"videoClips": [{"id": "v0", "name": "$name (AutoCut)", "img": "$img", "startMs": 0, "endMs": 10000, "offsetMs": 0}], "audioClips": [{"id": "a0", "name": "AutoCut Beats.mp3", "startMs": 0, "endMs": 10000, "offsetMs": 0}], "textClips": [{"id": "t0", "name": "AutoCut Text", "startMs": 0, "endMs": 8000, "offsetMs": 0}], "aspectRatio": "16:9", "totalDurationMs": 10000}'
      };

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('AI AutoCut assembled successfully!'), backgroundColor: VibeCutColors.success),
        );
        Navigator.pushReplacementNamed(context, '/editor', arguments: template);
      }
    }
  }

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
            color: VibeCutColors.textPrimary,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: VibeCutColors.textPrimary, size: 28),
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
                    _buildToolItem(Icons.face_retouching_natural_outlined, 'Retouch', onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Face Retouch tool active'), duration: Duration(seconds: 1)),
                      );
                    }),
                    _buildToolItem(Icons.closed_caption_outlined, 'Auto captions', onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Captions will generate on import'), duration: Duration(seconds: 1)),
                      );
                    }),
                    _buildToolItem(Icons.speaker_notes_outlined, 'Teleprompter', onTap: () => _showMockTeleprompter(context)),
                    _buildToolItem(Icons.camera_alt_outlined, 'Camera', onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Camera capture module initialized'), duration: Duration(seconds: 1)),
                      );
                    }),
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
                    _buildToolItem(Icons.auto_awesome_outlined, 'AutoCut', onTap: () => _handleAutoCut(context)),
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
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/editor');
              },
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
                      color: VibeCutColors.primary.withOpacity(0.25),
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
        color: VibeCutColors.textPrimary,
      ),
    );
  }

  Widget _buildToolItem(IconData icon, String label, {bool isPro = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Column(
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
                  border: Border.all(color: VibeCutColors.textMuted.withOpacity(0.5), width: 0.5),
                ),
                child: Icon(icon, size: 26, color: VibeCutColors.textPrimary),
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
      ),
    );
  }
}
