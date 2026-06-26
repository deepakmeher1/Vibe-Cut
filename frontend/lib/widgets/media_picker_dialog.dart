import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';

class MediaPickerDialog extends StatefulWidget {
  const MediaPickerDialog({super.key});

  @override
  State<MediaPickerDialog> createState() => _MediaPickerDialogState();
}

class _MediaPickerDialogState extends State<MediaPickerDialog> {
  int _activeCategoryIndex = 0; // 0 = Videos, 1 = Photos
  final List<Map<String, String>> _mockVideos = [
    {'name': 'Beach Waves', 'duration': '00:12', 'img': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=200'},
    {'name': 'Urban Street', 'duration': '00:08', 'img': 'https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?q=80&w=200'},
    {'name': 'Nature Forest', 'duration': '00:15', 'img': 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?q=80&w=200'},
    {'name': 'Slow Dancing', 'duration': '00:10', 'img': 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?q=80&w=200'},
    {'name': 'Neon City Lights', 'duration': '00:18', 'img': 'https://images.unsplash.com/photo-1519501025264-65ba15a82390?q=80&w=200'},
    {'name': 'Campfire Nights', 'duration': '00:06', 'img': 'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?q=80&w=200'},
  ];

  final List<Map<String, String>> _mockPhotos = [
    {'name': 'Mountain Peak', 'img': 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?q=80&w=200'},
    {'name': 'Coffee Table', 'img': 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?q=80&w=200'},
    {'name': 'Retro Vinyl', 'img': 'https://images.unsplash.com/photo-1539625318667-15c057e62be5?q=80&w=200'},
    {'name': 'Desk Setup', 'img': 'https://images.unsplash.com/photo-1499951360447-b19be8fe80f5?q=80&w=200'},
  ];

  @override
  Widget build(BuildContext context) {
    final mediaList = _activeCategoryIndex == 0 ? _mockVideos : _mockPhotos;

    return Dialog(
      backgroundColor: VibeCutColors.background,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header options
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: VibeCutColors.textPrimary),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  'Select Media',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: VibeCutColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Albums',
                    style: GoogleFonts.outfit(
                      color: VibeCutColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Category selection tabs (Videos, Photos)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                _buildCategoryTab(0, 'Videos'),
                const SizedBox(width: 16),
                _buildCategoryTab(1, 'Photos'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: VibeCutColors.textMuted, height: 1),
          
          // Media Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.0,
              ),
              itemCount: mediaList.length,
              itemBuilder: (context, index) {
                final item = mediaList[index];
                return GestureDetector(
                  onTap: () {
                    // Return the selected media item details to caller
                    Navigator.pop(context, item);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            item['img']!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        
                        // Show duration on videos
                        if (_activeCategoryIndex == 0)
                          Positioned(
                            bottom: 6,
                            right: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item['duration']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(int index, String label) {
    final isActive = _activeCategoryIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeCategoryIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isActive ? VibeCutColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            color: isActive ? VibeCutColors.primary : VibeCutColors.textSecondary,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
