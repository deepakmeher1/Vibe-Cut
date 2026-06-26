import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/colors.dart';
import '../../services/api_service.dart';

class EditTab extends StatefulWidget {
  final VoidCallback onOpenAllTools;
  final Function(int) onChangeTab;

  const EditTab({
    super.key, 
    required this.onOpenAllTools,
    required this.onChangeTab,
  });

  @override
  State<EditTab> createState() => _EditTabState();
}

class _EditTabState extends State<EditTab> {
  List<dynamic> _recentProjects = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadRecentProjects();
  }

  Future<void> _loadRecentProjects() async {
    if (!ApiService().isAuthenticated) return;
    setState(() {
      _loading = true;
    });
    try {
      final list = await ApiService().getProjects();
      // Keep only first 3 items
      setState(() {
        _recentProjects = list.take(3).toList();
      });
    } catch (e) {
      // Quietly fail
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasBackendProjects = ApiService().isAuthenticated && _recentProjects.isNotEmpty;
    final displayProjects = hasBackendProjects
        ? _recentProjects
        : [
            {'id': -1, 'name': 'Beach Waves Draft', 'duration': '00:12', 'size': '41MB', 'thumbnail': 'https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c?q=80&w=150', 'created_at': '2026-06-23T11:47:00Z'},
            {'id': -2, 'name': 'Dance Segment', 'duration': '00:10', 'size': '155MB', 'thumbnail': 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?q=80&w=150', 'created_at': '2026-06-23T11:31:00Z'},
            {'id': -3, 'name': 'Yoga Session', 'duration': '00:19', 'size': '45MB', 'thumbnail': 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?q=80&w=150', 'created_at': '2026-06-22T16:10:00Z'},
          ];

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
                image: NetworkImage('https://images.unsplash.com/photo-1574717024653-61fd2cf4d44d?q=80&w=600&auto=format&fit=crop'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
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
                      color: VibeCutColors.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'SEEDANCE 2.0 MINI',
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Fast style, spend less',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      color: Colors.white70,
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      await Navigator.pushNamed(context, '/editor');
                      _loadRecentProjects();
                    },
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: VibeCutColors.primaryGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: VibeCutColors.primary.withOpacity(0.25),
                            blurRadius: 12,
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
                
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: VibeCutColors.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.photo_library_outlined, size: 36, color: VibeCutColors.textPrimary),
                          const SizedBox(height: 8),
                          Text(
                            'Edit photo',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: VibeCutColors.textPrimary,
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

          // 3. Quick Action Grid
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
                    color: VibeCutColors.primary,
                    onTap: widget.onOpenAllTools
                  ),
                ],
              ),
            ),
          ),

          // 4. Projects Section Header
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Projects',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: VibeCutColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    widget.onChangeTab(2); // Switch to Projects Tab
                  },
                  child: Text(
                    'View all',
                    style: GoogleFonts.outfit(
                      color: VibeCutColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Projects List
          _loading
              ? const Center(child: CircularProgressIndicator(color: VibeCutColors.primary))
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayProjects.length,
                  itemBuilder: (context, index) {
                    final proj = displayProjects[index];
                    final projId = proj['id'] as int;
                    final thumbnail = proj['thumbnail'] ?? proj['img'] ?? 'https://images.unsplash.com/photo-1574717024653-61fd2cf4d44d?q=80&w=150';

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: VibeCutColors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () async {
                          if (projId >= 0) {
                            await Navigator.pushNamed(context, '/editor', arguments: projId);
                            _loadRecentProjects();
                          } else {
                            Navigator.pushNamed(context, '/editor');
                          }
                        },
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                thumbnail,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 14),
                            
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    proj['name']!,
                                    style: GoogleFonts.outfit(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: VibeCutColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    proj['created_at'] != null 
                                        ? proj['created_at'].toString().substring(0, 10) 
                                        : proj['date'] ?? 'Recent',
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
                                        '${proj['duration'] ?? proj['time']} | ${proj['size']}',
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
                            
                            IconButton(
                              icon: const Icon(Icons.more_vert, color: VibeCutColors.textSecondary),
                              onPressed: () {},
                            ),
                          ],
                        ),
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
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: VibeCutColors.textMuted, width: 1),
            ),
            child: Icon(icon, size: 22, color: color ?? VibeCutColors.textPrimary),
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
