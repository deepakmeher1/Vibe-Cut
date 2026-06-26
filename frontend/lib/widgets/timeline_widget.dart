import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/colors.dart';
import '../providers/editor_provider.dart';

class TimelineWidget extends StatelessWidget {
  final VoidCallback onImportMedia;

  const TimelineWidget({
    super.key,
    required this.onImportMedia,
  });

  String _formatMs(int ms) {
    final int totalSeconds = ms ~/ 1000;
    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final editorState = Provider.of<EditorProvider>(context);
    final hasMedia = editorState.videoClips.isNotEmpty;

    // Conversion ratio: 80 logical pixels per second (1000 milliseconds)
    const double pixelsPerMs = 0.08;
    final double timelineWidth = editorState.totalDurationMs * pixelsPerMs;

    return Container(
      color: VibeCutColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline Content
          Expanded(
            child: hasMedia
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTapDown: (details) {
                        // Tapping timeline seeks to clicked coordinate
                        final double localX = details.localPosition.dx;
                        final double targetMs = localX / pixelsPerMs;
                        editorState.seekTo(targetMs.round());
                      },
                      child: Container(
                        width: timelineWidth + 100, // padded width
                        color: Colors.transparent,
                        child: Stack(
                          children: [
                            // 1. Grid Ruler Markers
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              height: 30,
                              child: Row(
                                children: List.generate(
                                  (editorState.totalDurationMs ~/ 1000) + 2,
                                  (index) {
                                    final int second = index;
                                    return Container(
                                      width: 1000 * pixelsPerMs,
                                      alignment: Alignment.bottomLeft,
                                      padding: const EdgeInsets.only(left: 4, bottom: 4),
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          left: BorderSide(color: VibeCutColors.textSecondary, width: 0.5),
                                        ),
                                      ),
                                      child: Text(
                                        '00:${second.toString().padLeft(2, '0')}',
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
                            ),

                            // 2. Track Rows Content
                            Positioned(
                              top: 35,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // A. VIDEO CLIPS ROW
                                  _buildTrackHeader('Video Track'),
                                  Container(
                                    height: 52,
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      children: editorState.videoClips.map((clip) {
                                        final double clipWidth = ((clip['endMs'] as int) - (clip['startMs'] as int)) * pixelsPerMs;
                                        final clipDurationStr = _formatMs((clip['endMs'] as int) - (clip['startMs'] as int));

                                        return Container(
                                          width: clipWidth,
                                          height: 52,
                                          margin: const EdgeInsets.only(right: 1.5),
                                          decoration: BoxDecoration(
                                            color: VibeCutColors.primary.withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(color: VibeCutColors.primary, width: 1.5),
                                          ),
                                          child: Row(
                                            children: [
                                              if (clip['img'] != null)
                                                ClipRRect(
                                                  borderRadius: const BorderRadius.only(
                                                    topLeft: Radius.circular(4),
                                                    bottomLeft: Radius.circular(4),
                                                  ),
                                                  child: Image.network(
                                                    clip['img'],
                                                    width: 48,
                                                    height: 48,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  clip['name'] ?? 'Video Segment',
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                    color: VibeCutColors.textPrimary,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                                margin: const EdgeInsets.only(right: 6),
                                                decoration: BoxDecoration(
                                                  color: Colors.black.withOpacity(0.6),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  clipDurationStr,
                                                  style: const TextStyle(color: Colors.white, fontSize: 8),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  const Divider(color: VibeCutColors.textMuted, height: 10),

                                  // B. AUDIO TRACKS STACK
                                  _buildTrackHeader('Audio Track'),
                                  Container(
                                    height: 38,
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    child: Stack(
                                      children: editorState.audioClips.map((clip) {
                                        final double leftOffset = (clip['offsetMs'] as int) * pixelsPerMs;
                                        final double clipWidth = ((clip['endMs'] as int) - (clip['startMs'] as int)) * pixelsPerMs;

                                        return Positioned(
                                          left: leftOffset,
                                          width: clipWidth,
                                          height: 32,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: VibeCutColors.secondary.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(color: VibeCutColors.secondary.withOpacity(0.6), width: 1),
                                            ),
                                            child: Row(
                                              children: [
                                                const SizedBox(width: 6),
                                                const Icon(Icons.music_note, size: 14, color: VibeCutColors.secondary),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    clip['name'] ?? 'Music.mp3',
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.outfit(fontSize: 9, color: VibeCutColors.textPrimary),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.close, size: 12, color: VibeCutColors.textSecondary),
                                                  padding: EdgeInsets.zero,
                                                  constraints: const BoxConstraints(),
                                                  onPressed: () {
                                                    editorState.removeAudioClip(clip['id']);
                                                  },
                                                ),
                                                const SizedBox(width: 4),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  const Divider(color: VibeCutColors.textMuted, height: 10),

                                  // C. TEXT / SUBTITLE TRACKS STACK
                                  _buildTrackHeader('Text / Titles'),
                                  Container(
                                    height: 32,
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    child: Stack(
                                      children: editorState.textClips.map((clip) {
                                        final double leftOffset = (clip['offsetMs'] as int) * pixelsPerMs;
                                        final double clipWidth = ((clip['endMs'] as int) - (clip['startMs'] as int)) * pixelsPerMs;

                                        return Positioned(
                                          left: leftOffset,
                                          width: clipWidth,
                                          height: 28,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: VibeCutColors.accent.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(color: VibeCutColors.accent.withOpacity(0.6), width: 1),
                                            ),
                                            child: Row(
                                              children: [
                                                const SizedBox(width: 6),
                                                const Icon(Icons.title, size: 12, color: VibeCutColors.accent),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    clip['name'] ?? 'Subtitle',
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.outfit(fontSize: 9, color: VibeCutColors.textPrimary),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.close, size: 12, color: VibeCutColors.textSecondary),
                                                  padding: EdgeInsets.zero,
                                                  constraints: const BoxConstraints(),
                                                  onPressed: () {
                                                    editorState.removeTextClip(clip['id']);
                                                  },
                                                ),
                                                const SizedBox(width: 4),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // 3. Playhead Marker Line (drawn at active playhead position)
                            Positioned(
                              left: editorState.playheadMs * pixelsPerMs,
                              top: 0,
                              bottom: 0,
                              child: IgnorePointer(
                                child: Container(
                                  width: 2.0,
                                  color: Colors.red,
                                ),
                              ),
                            ),

                            // 4. Playhead Top arrow
                            Positioned(
                              left: (editorState.playheadMs * pixelsPerMs) - 5,
                              top: 0,
                              child: IgnorePointer(
                                child: Container(
                                  width: 12,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(6),
                                      bottomRight: Radius.circular(6),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Center(child: _buildImportPrompt(onImportMedia)),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 10,
          color: VibeCutColors.textSecondary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildImportPrompt(VoidCallback onImport) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.movie_filter_outlined, size: 48, color: VibeCutColors.textSecondary),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onImport,
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Import Video'),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: VibeCutColors.primary, width: 1.5),
            foregroundColor: VibeCutColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ],
    );
  }
}
