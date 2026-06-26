import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/colors.dart';
import '../providers/editor_provider.dart';

class VideoPlayerWidget extends StatelessWidget {
  const VideoPlayerWidget({super.key});

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
    // Get thumbnail of the first video clip
    final mediaImg = hasMedia 
        ? editorState.videoClips.first['img'] ?? 'https://images.unsplash.com/photo-1574717024653-61fd2cf4d44d?q=80&w=600'
        : 'https://images.unsplash.com/photo-1574717024653-61fd2cf4d44d?q=80&w=600';
    
    final durationStr = _formatMs(editorState.totalDurationMs);
    final elapsedStr = _formatMs(editorState.playheadMs);

    return Container(
      color: Colors.black, // Active video frames are always framed in pure black
      child: AspectRatio(
        aspectRatio: editorState.aspectRatioLabel == "16:9" 
            ? 16 / 9 
            : editorState.aspectRatioLabel == "9:16" 
                ? 9 / 16 
                : 1 / 1,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Video Frame backdrop
            Positioned.fill(
              child: Opacity(
                opacity: hasMedia ? 1.0 : 0.4,
                child: Image.network(
                  mediaImg,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            // Blank prompt overlay when no media loaded
            if (!hasMedia)
              Positioned.fill(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.video_library_outlined, size: 48, color: Colors.white60),
                      const SizedBox(height: 12),
                      Text(
                        'Tap "+ Import" below to start editing',
                        style: GoogleFonts.outfit(
                          color: Colors.white70,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Play / Pause controls
            if (hasMedia)
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      editorState.togglePlay();
                    },
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        child: Icon(
                          editorState.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // Seek progress bar overlay at the bottom of the video player
            if (hasMedia)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      // Active Timestamp
                      Text(
                        elapsedStr,
                        style: GoogleFonts.outfit(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      
                      // Progress slider track
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            thumbColor: VibeCutColors.primary,
                            activeTrackColor: VibeCutColors.primary,
                            inactiveTrackColor: Colors.white30,
                            trackHeight: 2,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                            overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                          ),
                          child: Slider(
                            value: editorState.playheadProgress,
                            onChanged: (value) {
                              editorState.seekProgress(value);
                            },
                          ),
                        ),
                      ),
                      
                      // Ending Timestamp
                      Text(
                        durationStr,
                        style: GoogleFonts.outfit(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
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
