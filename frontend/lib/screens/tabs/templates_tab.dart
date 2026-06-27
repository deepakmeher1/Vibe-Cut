import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/colors.dart';
import '../../services/api_service.dart';

class TemplatesTab extends StatefulWidget {
  const TemplatesTab({super.key});

  @override
  State<TemplatesTab> createState() => _TemplatesTabState();
}

class _TemplatesTabState extends State<TemplatesTab> {
  List<dynamic> _templates = [];
  bool _loading = false;
  String _activeCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _fetchTemplates();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _fetchTemplates() async {
    setState(() {
      _loading = true;
    });
    try {
      final list = await ApiService().getTemplates(
        category: _activeCategory,
        query: _searchController.text.trim(),
      );
      setState(() {
        _templates = list;
      });
    } catch (e) {
      // Quiet fail
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _onSearchChanged(String val) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchTemplates();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Search Bar Header
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: VibeCutColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    style: GoogleFonts.outfit(color: VibeCutColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Search templates, creators...',
                      hintStyle: GoogleFonts.outfit(color: VibeCutColors.textSecondary.withOpacity(0.5)),
                      prefixIcon: const Icon(Icons.search, color: VibeCutColors.textSecondary),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // AutoCut trigger icon
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: VibeCutColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.movie_creation_outlined, color: VibeCutColors.primary),
              ),
            ],
          ),
        ),

        // 2. Sub-Category Tabs (All, AI effects, Cinematic)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              _buildCategoryChip('All'),
              const SizedBox(width: 12),
              _buildCategoryChip('AI effects'),
              const SizedBox(width: 12),
              _buildCategoryChip('Cinematic'),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 3. Grid List of templates
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator(color: VibeCutColors.primary))
              : _templates.isEmpty
                  ? Center(
                      child: Text(
                        'No templates found',
                        style: GoogleFonts.outfit(color: VibeCutColors.textSecondary, fontSize: 15),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: _templates.length,
                      itemBuilder: (context, index) {
                        final tmpl = _templates[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context, 
                              '/editor', 
                              arguments: Map<String, dynamic>.from(tmpl),
                            );
                          },
                          child: _buildTemplateCard(tmpl),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String label) {
    final isActive = _activeCategory == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeCategory = label;
        });
        _fetchTemplates();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? VibeCutColors.primary : VibeCutColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            color: isActive ? Colors.white : VibeCutColors.textSecondary,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateCard(Map<String, dynamic> tmpl) {
    final title = tmpl['title'] as String? ?? 'Template';
    final author = tmpl['author'] as String? ?? 'Creator';
    final views = tmpl['views'] as String? ?? '0';
    final imgUrl = tmpl['thumbnail_url'] as String? ?? 'https://images.unsplash.com/photo-1574717024653-61fd2cf4d44d?q=80&w=300';
    final isAi = tmpl['is_ai'] as bool? ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Image preview with overlay badges
        Expanded(
          child: Stack(
            children: [
              // Image background
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imgUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              // Views count overlay (bottom left)
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.play_arrow, size: 10, color: Colors.white),
                      const SizedBox(width: 2),
                      Text(
                        views,
                        style: GoogleFonts.outfit(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),

              // AI Badge (bottom right)
              if (isAi)
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: VibeCutColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'AI',
                      style: GoogleFonts.outfit(
                        fontSize: 9, 
                        color: Colors.white, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Template title
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: VibeCutColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        
        // Author details
        Row(
          children: [
            CircleAvatar(
              radius: 8,
              backgroundColor: VibeCutColors.primary.withOpacity(0.2),
              child: Text(
                author.isNotEmpty ? author[0].toUpperCase() : 'C', 
                style: const TextStyle(fontSize: 8, color: VibeCutColors.primary),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                author,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  color: VibeCutColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
