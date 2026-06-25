import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';
import 'tabs/edit_tab.dart';
import 'tabs/templates_tab.dart';
import 'tabs/projects_tab.dart';
import 'tabs/profile_tab.dart';
import 'tools_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentTabIndex = 0;

  void _openAllToolsPanel() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ToolsScreen()),
    );
  }

  void _changeTab(int index) {
    setState(() {
      _currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      EditTab(
        onOpenAllTools: _openAllToolsPanel,
        onChangeTab: _changeTab,
      ),
      const TemplatesTab(),
      const ProjectsTab(),
      const ProfileTab(),
    ];

    return Scaffold(
      backgroundColor: VibeCutColors.background,
      appBar: _currentTabIndex == 0 
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Row(
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => VibeCutColors.neonGradient.createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                    child: Text(
                      'VibeCut',
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              centerTitle: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.settings_outlined, color: Colors.white),
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
              ],
            )
          : null, // Sub-pages will manage their own headers
      body: SafeArea(
        child: IndexedStack(
          index: _currentTabIndex,
          children: tabs,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: VibeCutColors.textMuted, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentTabIndex,
          onTap: _changeTab,
          type: BottomNavigationBarType.fixed,
          backgroundColor: VibeCutColors.background,
          selectedItemColor: VibeCutColors.secondary,
          unselectedItemColor: VibeCutColors.textSecondary,
          selectedLabelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w500, fontSize: 11),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.cut_outlined),
              activeIcon: Icon(Icons.cut, color: VibeCutColors.secondary),
              label: 'Edit',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.movie_filter_outlined),
              activeIcon: Icon(Icons.movie_filter, color: VibeCutColors.secondary),
              label: 'Templates',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_open_outlined),
              activeIcon: Icon(Icons.folder, color: VibeCutColors.secondary),
              label: 'Projects',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded, color: VibeCutColors.secondary),
              label: 'Me',
            ),
          ],
        ),
      ),
    );
  }
}
