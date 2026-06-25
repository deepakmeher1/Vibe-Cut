import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/colors.dart';

class ProjectsTab extends StatefulWidget {
  const ProjectsTab({super.key});

  @override
  State<ProjectsTab> createState() => _ProjectsTabState();
}

class _ProjectsTabState extends State<ProjectsTab> {
  int _activeSubTab = 0; // 0 = Local, 1 = Spaces, 2 = Media, 3 = Trash
  int _activeFilterIndex = 0; // 0 = All, 1 = Video, 2 = Photo

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Projects Top Header Options (Search, Sort, More)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Projects',
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: VibeCutColors.textPrimary,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search, color: VibeCutColors.textPrimary),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.sort_rounded, color: VibeCutColors.textPrimary),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_horiz, color: VibeCutColors.textPrimary),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. Sub Tabs (Local, Spaces, Media, Trash) - Active border is black
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  _buildSubTab(0, 'Local'),
                  _buildSubTab(1, 'Spaces'),
                  _buildSubTab(2, 'Media'),
                  _buildSubTab(3, 'Trash'),
                ],
              ),
            ),
            const Divider(color: VibeCutColors.textMuted, height: 1),
            const SizedBox(height: 12),

            // 3. Category Filter Chips (All, Video, Photo, Template, Camera)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildFilterChip(0, 'All'),
                  _buildFilterChip(1, 'Video'),
                  _buildFilterChip(2, 'Photo'),
                  _buildFilterChip(3, 'Template'),
                  _buildFilterChip(4, 'Camera'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 4. Projects List or Cloud Sync Prompt
            Expanded(
              child: _activeSubTab == 1 
                  ? _buildCloudSpacesPrompt() 
                  : _buildLocalProjectsList(), 
            ),
          ],
        ),

        // 5. Floating + Create Action Button (Cyan background, black icon/text - matching screenshot 2)
        Positioned(
          bottom: 24,
          right: 24,
          child: FloatingActionButton.extended(
            onPressed: () {},
            backgroundColor: VibeCutColors.primary,
            foregroundColor: Colors.black,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            icon: const Icon(Icons.add, size: 24, color: Colors.black),
            label: Text(
              'Create',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubTab(int index, String label) {
    final isActive = _activeSubTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _activeSubTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? Colors.black : Colors.transparent,
                width: 2.5,
              ),
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.outfit(
              color: isActive ? Colors.black : VibeCutColors.textSecondary,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(int index, String label) {
    final isActive = _activeFilterIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeFilterIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.black : VibeCutColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: isActive ? null : Border.all(color: VibeCutColors.textMuted.withOpacity(0.5), width: 0.5),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            color: isActive ? Colors.white : VibeCutColors.textSecondary,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildLocalProjectsList() {
    final projects = [
      {'name': '0623', 'date': '06/23/2026 11:47', 'time': '00:07', 'size': '41MB', 'img': 'https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c?q=80&w=150'},
      {'name': '0619', 'date': '06/23/2026 11:31', 'time': '00:09', 'size': '155MB', 'img': 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?q=80&w=150'},
      {'name': 'Yoga', 'date': '06/22/2026 16:10', 'time': '00:19', 'size': '45MB', 'img': 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?q=80&w=150'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final proj = projects[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: VibeCutColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  proj['img']!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      proj['name']!,
                      style: GoogleFonts.outfit(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: VibeCutColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      proj['date']!,
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        color: VibeCutColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined, size: 14, color: VibeCutColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          '${proj['time']} | ${proj['size']}',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: VibeCutColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, color: VibeCutColors.textSecondary),
                onPressed: () {},
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCloudSpacesPrompt() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: VibeCutColors.primary.withOpacity(0.1),
            ),
            child: const Icon(Icons.cloud_upload_outlined, size: 64, color: VibeCutColors.primary),
          ),
          const SizedBox(height: 24),
          Text(
            'Upload & Manage Projects',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: VibeCutColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sign in to sync your VibeCut drafts to your secure cloud space and edit across devices.',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: VibeCutColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              backgroundColor: VibeCutColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Sign In',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
