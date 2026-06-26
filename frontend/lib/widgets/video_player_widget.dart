import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';

class VideoPlayerWidget extends StatefulWidget {
  final Map<String, String>? selectedMedia;

  const VideoPlayerWidget({
    super.key,
    required this.selectedMedia,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  bool _isPlaying = false;
  double _currentProgress = 0.2; // Mock progress (20% through video)

  @override
  Widget build(BuildContext context) {
    final hasMedia = widget.selectedMedia != null;
    final mediaImg = widget.selectedMedia?['img'] ?? 'https://images.unsplash.com/photo-1574717024653-61fd2cf4d44d?q=80&w=600'; // Fallback backdrop
    final mediaDuration = widget.selectedMedia?['duration'] ?? '00:15';

    return Container(
      color: Colors.black, // Active video frames are always framed in pure black
      child: AspectRatio(
        aspectRatio: 16 / 9,
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
                      setState(() {
                        _isPlaying = !_isPlaying;
                      });
                    },
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        child: Icon(
                          _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
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
                        '00:03',
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
                            value: _currentProgress,
                            onChanged: (value) {
                              setState(() {
                                _currentProgress = value;
                              });
                            },
                          ),
                        ),
                      ),
                      
                      // Ending Timestamp
                      Text(
                        mediaDuration,
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
