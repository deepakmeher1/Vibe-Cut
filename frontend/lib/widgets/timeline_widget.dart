import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';

class TimelineWidget extends StatelessWidget {
  final Map<String, String>? selectedMedia;
  final VoidCallback onImportMedia;

  const TimelineWidget({
    super.key,
    required this.selectedMedia,
    required this.onImportMedia,
  });

  @override
  Widget build(BuildContext context) {
    final hasMedia = selectedMedia != null;
    final mediaName = selectedMedia?['name'] ?? '';
    final mediaImg = selectedMedia?['img'] ?? '';
    final mediaDuration = selectedMedia?['duration'] ?? '00:15';

    return Container(
      color: VibeCutColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Time Ruler Header
          Container(
            height: 28,
            color: VibeCutColors.surface,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 15,
              itemBuilder: (context, index) {
                return Container(
                  width: 60,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 4),
                  decoration: const BoxDecoration(
                    border: Border(left: BorderSide(color: VibeCutColors.textMuted, width: 0.5)),
                  ),
                  child: Text(
                    '00:${index.toString().padLeft(2, '0')}',
                    style: GoogleFonts.outfit(
                      fontSize: 9,
                      color: VibeCutColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
          
          // 2. Playhead Center line + Scrollable track lists
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Scrollable Tracks Area
                ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    // A. VIDEO TRACK LAYER
                    _buildTrackHeader('Video Track'),
                    Container(
                      height: 52,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: hasMedia
                          ? Row(
                              children: [
                                const SizedBox(width: 80), // Offset to align clip under playhead initially
                                // Video Clip Block
                                Container(
                                  width: 220,
                                  decoration: BoxDecoration(
                                    color: VibeCutColors.primary.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: VibeCutColors.primary, width: 1.5),
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(6), 
                                          bottomLeft: Radius.circular(6)
                                        ),
                                        child: Image.network(
                                          mediaImg,
                                          width: 52,
                                          height: 52,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          mediaName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.outfit(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: VibeCutColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        margin: const EdgeInsets.only(right: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.6),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          mediaDuration,
                                          style: const TextStyle(color: Colors.white, fontSize: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : _buildImportPrompt(onImportMedia),
                    ),
                    const Divider(color: VibeCutColors.textMuted, height: 16),

                    // B. AUDIO TRACK LAYER
                    _buildTrackHeader('Audio Track'),
                    Container(
                      height: 38,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: hasMedia
                          ? Row(
                              children: [
                                const SizedBox(width: 100),
                                // Audio block waveform mockup
                                Container(
                                  width: 160,
                                  decoration: BoxDecoration(
                                    color: VibeCutColors.secondary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: VibeCutColors.secondary.withOpacity(0.6), width: 1),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 8),
                                      const Icon(Icons.music_note, size: 16, color: VibeCutColors.secondary),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          'Background_Music.mp3',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.outfit(fontSize: 10, color: VibeCutColors.textPrimary),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : _buildEmptyTrackPlaceholder('Add music track'),
                    ),
                    const Divider(color: VibeCutColors.textMuted, height: 16),

                    // C. TEXT TRACK LAYER
                    _buildTrackHeader('Text / Titles'),
                    Container(
                      height: 32,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: hasMedia
                          ? Row(
                              children: [
                                const SizedBox(width: 140),
                                // Text span block mockup
                                Container(
                                  width: 110,
                                  decoration: BoxDecoration(
                                    color: VibeCutColors.accent.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: VibeCutColors.accent.withOpacity(0.6), width: 1),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 8),
                                      const Icon(Icons.title, size: 14, color: VibeCutColors.accent),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          'Subtitle title',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.outfit(fontSize: 10, color: VibeCutColors.textPrimary),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : _buildEmptyTrackPlaceholder('Add text overlay'),
                    ),
                  ],
                ),
                
                // Red Playhead Marker Line (centered)
                IgnorePointer(
                  child: Container(
                    width: 2.5,
                    color: Colors.red,
                  ),
                ),
                
                // Red Playhead Top Marker Arrow
                Positioned(
                  top: 0,
                  child: Container(
                    width: 12,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(6),
                        bottomRight: Radius.circular(6)
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 11,
          color: VibeCutColors.textSecondary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildImportPrompt(VoidCallback onImport) {
    return Center(
      child: OutlinedButton.icon(
        onPressed: onImport,
        icon: const Icon(Icons.add, size: 16),
        label: const Text('Import Video'),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: VibeCutColors.primary, width: 1),
          foregroundColor: VibeCutColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildEmptyTrackPlaceholder(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: VibeCutColors.textMuted.withOpacity(0.3), width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.outfit(fontSize: 12, color: VibeCutColors.textSecondary.withOpacity(0.5)),
          ),
        ),
      ),
    );
  }
}
