import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: const Text('Library'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildLibraryTile(
            context,
            icon: Icons.history,
            title: 'History',
            subtitle: 'Recently watched videos',
            color: AppColors.accentGlow,
            onTap: () => context.push('/history'),
          ),
          const SizedBox(height: 12),
          _buildLibraryTile(
            context,
            icon: Icons.favorite,
            title: 'Liked Videos',
            subtitle: 'Videos you have liked',
            color: AppColors.danger,
            onTap: () => context.push('/liked'),
          ),
          const SizedBox(height: 12),
          _buildLibraryTile(
            context,
            icon: Icons.playlist_play,
            title: 'Playlists',
            subtitle: 'Saved and custom playlists',
            color: AppColors.success,
            onTap: () => context.push('/playlists'),
          ),
          const SizedBox(height: 12),
          _buildLibraryTile(
            context,
            icon: Icons.dashboard_outlined,
            title: 'Creator Dashboard',
            subtitle: 'Manage your videos and stats',
            color: AppColors.info,
            onTap: () => context.push('/dashboard'),
          ),
          const SizedBox(height: 12),
          _buildLibraryTile(
            context,
            icon: Icons.settings_outlined,
            title: 'Settings',
            subtitle: 'Account and app preferences',
            color: AppColors.textSecondary,
            onTap: () => context.push('/settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildLibraryTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderDefault),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
