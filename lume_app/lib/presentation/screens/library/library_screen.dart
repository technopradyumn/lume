// lib/presentation/screens/library/library_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/video/video_cubit.dart';
import '../../blocs/video/video_state.dart';
import '../../blocs/playlist/playlist_cubit.dart';
import '../../blocs/playlist/playlist_state.dart';
import '../../widgets/video_card.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Only fetch data if not already loaded
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      final videoState = context.read<VideoCubit>().state;
      final playlistState = context.read<PlaylistCubit>().state;
      
      // Only fetch liked videos if not already loaded
      if (videoState is VideoInitial) {
        context.read<VideoCubit>().getLikedVideos();
      }
      
      // Only fetch playlists if not already loaded
      if (playlistState is PlaylistInitial) {
        context.read<PlaylistCubit>().fetchUserPlaylists(authState.user.id);
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Library'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSubtle,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Liked Videos'),
            Tab(text: 'Playlists'),
            Tab(text: 'Watch History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Liked Videos
          BlocBuilder<VideoCubit, VideoState>(
            builder: (context, state) {
              if (state is VideoLoading) {
                return ListView.builder(
                  itemCount: 5,
                  itemBuilder: (_, __) => const VideoCardSkeleton(),
                );
              }
              if (state is VideosLoaded) {
                if (state.videos.isEmpty) {
                  return const _EmptyState(
                    icon: Icons.thumb_up_outlined,
                    message: 'No liked videos yet',
                    subtitle: 'Videos you like will appear here',
                  );
                }
                return ListView.builder(
                  itemCount: state.videos.length,
                  itemBuilder: (context, i) => VideoCard(
                    video: state.videos[i],
                    onTap: () => context.push('/video/${state.videos[i].id}'),
                  ),
                );
              }
              return const SizedBox();
            },
          ),

          // Playlists
          BlocBuilder<PlaylistCubit, PlaylistState>(
            builder: (context, state) {
              if (state is PlaylistLoading) {
                return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(AppColors.primary)));
              }
              if (state is PlaylistsLoaded) {
                if (state.playlists.isEmpty) {
                  return const _EmptyState(
                    icon: Icons.playlist_play,
                    message: 'No playlists yet',
                    subtitle: 'Create a playlist to organize your videos',
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.playlists.length,
                  itemBuilder: (context, i) {
                    final p = state.playlists[i];
                    return ListTile(
                      leading: Container(
                        width: 56,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                          image: p.thumbnailUrl != null
                              ? DecorationImage(image: NetworkImage(p.thumbnailUrl!), fit: BoxFit.cover)
                              : null,
                        ),
                        child: p.thumbnailUrl == null ? const Icon(Icons.playlist_play, color: AppColors.textSubtle) : null,
                      ),
                      title: Text(p.name, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                      subtitle: Text('${p.videos.length} videos', style: const TextStyle(color: AppColors.textSecondary)),
                      onTap: () => context.push('/playlist/${p.id}'),
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),

          // Watch History (simplified - uses liked videos API for demo)
          const _EmptyState(
            icon: Icons.history,
            message: 'Watch history',
            subtitle: 'Videos you watch will appear here',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePlaylistDialog(context),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showCreatePlaylistDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Create Playlist', style: TextStyle(color: AppColors.textPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtrl,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final authState = context.read<AuthCubit>().state;
              if (authState is AuthAuthenticated && nameCtrl.text.isNotEmpty) {
                context.read<PlaylistCubit>().createPlaylist(nameCtrl.text, descCtrl.text, authState.user.id);
              }
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String subtitle;
  const _EmptyState({required this.icon, required this.message, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.textSubtle, size: 80),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: AppColors.textSecondary, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(color: AppColors.textSubtle, fontSize: 13)),
        ],
      ),
    );
  }
}
