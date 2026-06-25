import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/colors.dart';

class TemplatesTab extends StatelessWidget {
  const TemplatesTab({super.key});

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

        // 2. Sub-Category Tabs (All, AI effects)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              _buildCategoryChip('All', isActive: true),
              const SizedBox(width: 12),
              _buildCategoryChip('AI effects', isActive: false),
              const SizedBox(width: 12),
              _buildCategoryChip('Cinematic', isActive: false),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 3. Grid List of templates
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.65,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              final templates = [
                {
                  'title': 'Cinematic Video',
                  'author': 'GentleGiant Saint',
                  'views': '40.4K',
                  'isAi': true,
                  'img': 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?q=80&w=300'
                },
                {
                  'title': 'Sunset template',
                  'author': 'Mr. John',
                  'views': '1.3K',
                  'isAi': true,
                  'img': 'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?q=80&w=300'
                },
                {
                  'title': 'Retro Movie recap',
                  'author': 'Alex Media',
                  'views': '98.1K',
                  'isAi': false,
                  'img': 'https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?q=80&w=300'
                },
                {
                  'title': 'Cyberpunk Beats',
                  'author': 'VibeFX',
                  'views': '12.5K',
                  'isAi': true,
                  'img': 'https://images.unsplash.com/photo-1511512578047-dfb367046420?q=80&w=300'
                },
              ];
              
              final tmpl = templates[index];
              return _buildTemplateCard(
                tmpl['title'] as String,
                tmpl['author'] as String,
                tmpl['views'] as String,
                tmpl['img'] as String,
                tmpl['isAi'] as bool,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String label, {required bool isActive}) {
    return Container(
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
    );
  }

  Widget _buildTemplateCard(String title, String author, String views, String imgUrl, bool isAi) {
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

        // Template details
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
                author[0], 
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
