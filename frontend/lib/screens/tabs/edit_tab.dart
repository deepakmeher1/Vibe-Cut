import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/colors.dart';

class EditTab extends StatelessWidget {
  final VoidCallback onOpenAllTools;
  final Function(int) onChangeTab;

  const EditTab({
    super.key, 
    required this.onOpenAllTools,
    required this.onChangeTab,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Promotional Header Banner
          Container(
            height: 220,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1574717024653-61fd2cf4d44d?q=80&w=600&auto=format&fit=crop'), // Placeholder visual for music/dj vibes
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    VibeCutColors.background.withOpacity(0.9),
                    Colors.transparent,
                    VibeCutColors.background.withOpacity(0.95),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: VibeCutColors.secondary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'SEEDANCE 2.0 MINI',
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: VibeCutColors.background,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Fast style, spend less',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      color: VibeCutColors.textSecondary,
                    ),
                  ),
                  Text(
                    'Create stunning edits in one tap',
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 2. Central Action Cards (+ New Video & Edit Photo)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                // New Video Button (Gradient)
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to project template/draft creation in later phases
                    },
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: VibeCutColors.primaryGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: VibeCutColors.primary.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_box_rounded, size: 36, color: Colors.white),
                          const SizedBox(height: 8),
                          Text(
                            'New video',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Edit Photo Button (Card surface)
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: VibeCutColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: VibeCutColors.textMuted.withOpacity(0.3), width: 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.photo_library_outlined, size: 36, color: VibeCutColors.secondary),
                          const SizedBox(height: 8),
                          Text(
                            'Edit photo',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. Quick Action Grid (Horizontal scrollable or small Grid)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                color: VibeCutColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 8,
                childAspectRatio: 0.95,
                children: [
                  _buildQuickActionItem(Icons.auto_awesome_motion_outlined, 'AutoCut'),
                  _buildQuickActionItem(Icons.face_retouching_natural_outlined, 'Retouch'),
                  _buildQuickActionItem(Icons.closed_caption_outlined, 'Captions'),
                  _buildQuickActionItem(Icons.laptop_chromebook_outlined, 'Desktop'),
                  _buildQuickActionItem(Icons.portrait_outlined, 'Cutout'),
                  _buildQuickActionItem(Icons.filter_hdr_outlined, 'Enhance'),
                  _buildQuickActionItem(Icons.camera_alt_outlined, 'Camera'),
                  _buildQuickActionItem(
                    Icons.grid_view_rounded, 
                    'All tools', 
                    color: VibeCutColors.secondary,
                    onTap: onOpenAllTools
                  ),
                ],
              ),
            ),
          ),

          // 4. Projects Section
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Projects',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    onChangeTab(2); // Switch to Projects Tab
                  },
                  child: Text(
                    'View all',
                    style: GoogleFonts.outfit(
                      color: VibeCutColors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Projects List (Mock data matching screenshot 2/5)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              final projects = [
                {'name': '0623', 'date': '06/23/2026 11:47', 'time': '00:07', 'size': '41MB', 'img': 'https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c?q=80&w=150'},
                {'name': '0619', 'date': '06/23/2026 11:31', 'time': '00:09', 'size': '155MB', 'img': 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?q=80&w=150'},
                {'name': 'Yoga', 'date': '06/22/2026 16:10', 'time': '00:19', 'size': '45MB', 'img': 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?q=80&w=150'},
              ];
              final proj = projects[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: VibeCutColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    // Project Thumbnail
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        proj['img']!,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 14),
                    
                    // Project info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            proj['name']!,
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            proj['date']!,
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: VibeCutColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.movie_filter_outlined, size: 12, color: VibeCutColors.textSecondary.withOpacity(0.7)),
                              const SizedBox(width: 4),
                              Text(
                                '${proj['time']} | ${proj['size']}',
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  color: VibeCutColors.textSecondary.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Options button
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: VibeCutColors.textSecondary),
                      onPressed: () {},
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(IconData icon, String label, {Color? color, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: VibeCutColors.background,
              shape: BoxShape.circle,
              border: Border.all(color: VibeCutColors.textMuted.withOpacity(0.2), width: 1),
            ),
            child: Icon(icon, size: 22, color: color ?? Colors.white),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 11,
              color: VibeCutColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
