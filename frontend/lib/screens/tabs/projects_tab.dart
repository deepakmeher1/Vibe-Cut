import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/colors.dart';
import '../../services/api_service.dart';

class ProjectsTab extends StatefulWidget {
  const ProjectsTab({super.key});

  @override
  State<ProjectsTab> createState() => _ProjectsTabState();
}

class _ProjectsTabState extends State<ProjectsTab> {
  int _activeSubTab = 0; // 0 = Local, 1 = Spaces, 2 = Media, 3 = Trash
  int _activeFilterIndex = 0; // 0 = All, 1 = Video, 2 = Photo
  
  List<dynamic> _backendProjects = [];
  bool _loadingProjects = false;

  @override
  void initState() {
    super.initState();
    _loadBackendProjects();
  }

  Future<void> _loadBackendProjects() async {
    if (!ApiService().isAuthenticated) return;
    setState(() {
      _loadingProjects = true;
    });
    try {
      final list = await ApiService().getProjects();
      setState(() {
        _backendProjects = list;
      });
    } catch (e) {
      // Quietly fail or log
    } finally {
      setState(() {
        _loadingProjects = false;
      });
    }
  }

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
                        onPressed: _loadBackendProjects, // Pull to refresh
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
            onPressed: () async {
              await Navigator.pushNamed(context, '/editor');
              _loadBackendProjects();
            },
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
    if (_loadingProjects) {
      return const Center(child: CircularProgressIndicator(color: VibeCutColors.primary));
    }

    final projects = ApiService().isAuthenticated && _backendProjects.isNotEmpty
        ? _backendProjects
        : [
            {'id': -1, 'name': 'Beach Waves Draft', 'duration': '00:12', 'size': '41MB', 'thumbnail': 'https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c?q=80&w=150', 'created_at': '2026-06-23T11:47:00Z'},
            {'id': -2, 'name': 'Dance Segment', 'duration': '00:10', 'size': '155MB', 'thumbnail': 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?q=80&w=150', 'created_at': '2026-06-23T11:31:00Z'},
            {'id': -3, 'name': 'Yoga Session', 'duration': '00:19', 'size': '45MB', 'thumbnail': 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?q=80&w=150', 'created_at': '2026-06-22T16:10:00Z'},
          ];

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final proj = projects[index];
        final projId = proj['id'] as int;
        final thumbnail = proj['thumbnail'] ?? 'https://images.unsplash.com/photo-1574717024653-61fd2cf4d44d?q=80&w=150';

        return InkWell(
          onTap: () async {
            if (projId >= 0) {
              await Navigator.pushNamed(context, '/editor', arguments: projId);
              _loadBackendProjects();
            } else {
              Navigator.pushNamed(context, '/editor');
            }
          },
          child: Container(
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
                    thumbnail,
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
                        proj['created_at'] != null 
                            ? proj['created_at'].toString().substring(0, 10) 
                            : 'Recent Draft',
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
                            '${proj['duration']} | ${proj['size']}',
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
                if (projId >= 0)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: VibeCutColors.textSecondary),
                    onSelected: (value) async {
                      if (value == 'delete') {
                        try {
                          await ApiService().deleteProject(projId);
                          _loadBackendProjects();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Project deleted'), backgroundColor: VibeCutColors.success),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to delete: $e'), backgroundColor: VibeCutColors.error),
                            );
                          }
                        }
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete', style: TextStyle(color: VibeCutColors.error)),
                      ),
                    ],
                  ),
              ],
            ),
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
