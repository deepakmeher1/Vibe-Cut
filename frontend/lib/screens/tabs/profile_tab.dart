import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/colors.dart';
import '../../services/api_service.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  Map<String, dynamic>? _userData;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (!ApiService().isAuthenticated) return;
    setState(() {
      _loading = true;
    });
    try {
      final data = await ApiService().getMe();
      setState(() {
        _userData = data;
      });
    } catch (e) {
      // Quiet fail
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ApiService().isAuthenticated;
    final displayName = isLoggedIn 
        ? (_userData?['name'] != null && _userData!['name'].toString().isNotEmpty 
            ? _userData!['name'] 
            : _userData?['email'] ?? 'User') 
        : 'Guest Creator';
    
    final displayId = isLoggedIn 
        ? 'VibeCut ID: VC-${_userData?['id'] ?? '1001'}' 
        : 'Sign in to sync your timeline drafts';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Profile Details Header
          GestureDetector(
            onTap: () {
              if (!isLoggedIn) {
                Navigator.pushNamed(context, '/login');
              }
            },
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isLoggedIn ? VibeCutColors.primary.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                    border: Border.all(
                      color: isLoggedIn ? VibeCutColors.primary : Colors.grey,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person, 
                      size: 36, 
                      color: isLoggedIn ? VibeCutColors.primary : Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Username & ID details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: VibeCutColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        displayId,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: VibeCutColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLoggedIn)
                  const Icon(Icons.arrow_forward_ios, size: 14, color: VibeCutColors.textSecondary),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // 2. Settings Items List
          _buildSettingsItem(Icons.help_outline_rounded, 'Help Center'),
          _buildSettingsItem(
            Icons.person_outline_rounded, 
            isLoggedIn ? 'Manage Account (${_userData?['email'] ?? ''})' : 'Manage Account',
          ),
          _buildSettingsItem(Icons.history_rounded, 'View history'),
          _buildSettingsItem(Icons.qr_code_scanner_rounded, 'Scan'),
          
          const SizedBox(height: 60),
          const Divider(color: VibeCutColors.textMuted, height: 1),
          const SizedBox(height: 24),

          // 3. Bottom actions
          if (isLoggedIn) ...[
            _buildActionItem(Icons.swap_horiz_rounded, 'Switch account', onTap: () {
              ApiService().logout();
              Navigator.pushNamed(context, '/login');
            }),
            _buildActionItem(Icons.logout_rounded, 'Sign out', color: VibeCutColors.error, onTap: () {
              ApiService().logout();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Signed out successfully!'),
                  backgroundColor: VibeCutColors.warning,
                ),
              );
              Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);
            }),
          ] else
            _buildActionItem(Icons.login_rounded, 'Sign In', color: VibeCutColors.primary, onTap: () {
              Navigator.pushNamed(context, '/login');
            }),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            child: Row(
              children: [
                Icon(icon, size: 24, color: VibeCutColors.textPrimary),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: VibeCutColors.textPrimary,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 14, color: VibeCutColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String label, {Color? color, VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Row(
            children: [
              Icon(icon, size: 24, color: color ?? VibeCutColors.textPrimary),
              const SizedBox(width: 16),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color ?? VibeCutColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
