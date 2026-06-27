import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/colors.dart';
import '../widgets/video_player_widget.dart';
import '../widgets/timeline_widget.dart';
import '../widgets/media_picker_dialog.dart';
import '../providers/editor_provider.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      final provider = Provider.of<EditorProvider>(context, listen: false);
      if (args is int) {
        provider.loadProject(args);
      } else if (args is Map<String, dynamic>) {
        provider.loadTemplate(args);
      } else {
        provider.initNewProject("Project_${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}");
      }
    });
  }

  void _handleMediaPicker() async {
    final selected = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const MediaPickerDialog(),
    );
    if (selected != null) {
      if (mounted) {
        Provider.of<EditorProvider>(context, listen: false).importVideo(selected);
      }
    }
  }

  void _handleExport() async {
    final provider = Provider.of<EditorProvider>(context, listen: false);
    if (provider.videoClips.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please import a video first before exporting.'),
          backgroundColor: VibeCutColors.error,
        ),
      );
      return;
    }

    // Save project state to backend first
    try {
      await provider.saveProject();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save project to server: $e'),
            backgroundColor: VibeCutColors.error,
          ),
        );
      }
      return;
    }

    if (!mounted) return;

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
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Video exported and synced with backend successfully!'),
            backgroundColor: VibeCutColors.success,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final editorState = Provider.of<EditorProvider>(context);

    return Scaffold(
      backgroundColor: VibeCutColors.background,
      appBar: AppBar(
        backgroundColor: VibeCutColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: VibeCutColors.textPrimary, size: 20),
          onPressed: () {
            // Save state when exiting if has clips
            if (editorState.videoClips.isNotEmpty) {
              editorState.saveProject().catchError((e) {
                // Ignore background save errors on exit
              });
            }
            Navigator.pop(context);
          },
        ),
        title: Text(
          editorState.projectName,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          if (editorState.isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: VibeCutColors.primary),
                ),
              ),
            ),
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
      body: editorState.isLoading && editorState.videoClips.isEmpty
          ? const Center(child: CircularProgressIndicator(color: VibeCutColors.primary))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Video Player preview panel
                const VideoPlayerWidget(),
                
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
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Undo action'), duration: Duration(milliseconds: 500)),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.redo, size: 20, color: VibeCutColors.textPrimary),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Redo action'), duration: Duration(milliseconds: 500)),
                              );
                            },
                          ),
                        ],
                      ),
                      
                      // Aspect Ratio Selector
                      GestureDetector(
                        onTap: () {
                          final current = editorState.aspectRatioLabel;
                          final next = current == "16:9" 
                              ? "9:16" 
                              : current == "9:16" 
                                  ? "1:1" 
                                  : "16:9";
                          editorState.updateAspectRatio(next);
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
                                editorState.aspectRatioLabel,
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
                  child: TimelineWidget(onImportMedia: _handleMediaPicker),
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
                        if (editorState.videoClips.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please import a video first.'), backgroundColor: VibeCutColors.error),
                          );
                          return;
                        }
                        editorState.splitClip();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Video split successfully!'), backgroundColor: VibeCutColors.success),
                        );
                      }),
                      _buildToolOption(Icons.music_note_outlined, 'Audio', onTap: () async {
                        final selected = await showDialog<Map<String, String>>(
                          context: context,
                          builder: (context) => const MediaPickerDialog(),
                        );
                        if (selected != null) {
                          editorState.addAudio(selected);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Audio track added!'), backgroundColor: VibeCutColors.success),
                            );
                          }
                        }
                      }),
                      _buildToolOption(Icons.title_outlined, 'Text', onTap: () {
                        editorState.addText("Text Layer ${editorState.textClips.length + 1}");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Text overlay added!'), backgroundColor: VibeCutColors.success),
                        );
                      }),
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
