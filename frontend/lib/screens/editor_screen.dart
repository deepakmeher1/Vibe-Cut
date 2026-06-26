import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';
import '../widgets/video_player_widget.dart';
import '../widgets/timeline_widget.dart';
import '../widgets/media_picker_dialog.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  Map<String, String>? _selectedMedia;
  String _aspectRatioLabel = "16:9";

  void _handleMediaPicker() async {
    final selected = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const MediaPickerDialog(),
    );
    if (selected != null) {
      setState(() {
        _selectedMedia = selected;
      });
    }
  }

  void _handleExport() {
    if (_selectedMedia == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please import a video first before exporting.'),
          backgroundColor: VibeCutColors.error,
        ),
      );
      return;
    }
    
    // Simulate Video export
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: VibeCutColors.background,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: VibeCutColors.primary),
                const SizedBox(height: 24),
                Text(
                  'Exporting Video...',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18, color: VibeCutColors.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rendering 1080p | 60 FPS',
                  style: GoogleFonts.outfit(color: VibeCutColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Video exported successfully to your gallery!'),
          backgroundColor: VibeCutColors.success,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VibeCutColors.background,
      appBar: AppBar(
        backgroundColor: VibeCutColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: VibeCutColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _selectedMedia?['name'] ?? 'New Project',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          // Export Button (Cyan primary gradient)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: ElevatedButton(
              onPressed: _handleExport,
              style: ElevatedButton.styleFrom(
                backgroundColor: VibeCutColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                elevation: 0,
              ),
              child: Text(
                'Export',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Video Player preview panel
          VideoPlayerWidget(selectedMedia: _selectedMedia),
          
          // 2. Toolbar controls (Undo, Redo, Ratio)
          Container(
            color: VibeCutColors.surface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.undo, size: 20, color: VibeCutColors.textPrimary),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.redo, size: 20, color: VibeCutColors.textPrimary),
                      onPressed: () {},
                    ),
                  ],
                ),
                
                // Aspect Ratio Selector
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _aspectRatioLabel = _aspectRatioLabel == "16:9" 
                          ? "9:16" 
                          : _aspectRatioLabel == "9:16" 
                              ? "1:1" 
                              : "16:9";
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: VibeCutColors.textMuted, width: 1),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.aspect_ratio_outlined, size: 14, color: VibeCutColors.textPrimary),
                        const SizedBox(width: 6),
                        Text(
                          _aspectRatioLabel,
                          style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: VibeCutColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // 3. Timeline tracks view
          Expanded(
            child: TimelineWidget(
              selectedMedia: _selectedMedia,
              onImportMedia: _handleMediaPicker,
            ),
          ),
          
          // 4. Bottom Main Editing Tools Shelf
          Container(
            height: 72,
            color: VibeCutColors.background,
            border: const Border(top: BorderSide(color: VibeCutColors.textMuted, width: 0.5)),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                _buildToolOption(Icons.cut_outlined, 'Split', onTap: () {
                  if (_selectedMedia == null) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Video split successfully!'), backgroundColor: VibeCutColors.success),
                  );
                }),
                _buildToolOption(Icons.music_note_outlined, 'Audio'),
                _buildToolOption(Icons.title_outlined, 'Text'),
                _buildToolOption(Icons.filter_hdr_outlined, 'Filters'),
                _buildToolOption(Icons.star_outline_rounded, 'Effects'),
                _buildToolOption(Icons.photo_size_select_large_outlined, 'Canvas'),
                _buildToolOption(Icons.speed_outlined, 'Speed'),
                _buildToolOption(Icons.photo_filter_outlined, 'Overlays'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolOption(IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: VibeCutColors.textPrimary),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 11,
                color: VibeCutColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
