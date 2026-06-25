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
              backgroundColor: VibeCutColors.background,
              elevation: 0,
              title: Text(
                'VibeCut',
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: VibeCutColors.textPrimary,
                ),
              ),
              centerTitle: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: VibeCutColors.textPrimary),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.settings_outlined, color: VibeCutColors.textPrimary),
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
              ],
            )
          : null,
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
          selectedItemColor: VibeCutColors.textPrimary,
          unselectedItemColor: VibeCutColors.textSecondary,
          selectedLabelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w500, fontSize: 11),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.cut_outlined),
              activeIcon: Icon(Icons.cut, color: VibeCutColors.textPrimary),
              label: 'Edit',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.movie_filter_outlined),
              activeIcon: Icon(Icons.movie_filter, color: VibeCutColors.textPrimary),
              label: 'Templates',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_open_outlined),
              activeIcon: Icon(Icons.folder, color: VibeCutColors.textPrimary),
              label: 'Projects',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded, color: VibeCutColors.textPrimary),
              label: 'Me',
            ),
          ],
        ),
      ),
    );
  }
}
