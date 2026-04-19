// lib/presentation/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../blocs/video/video_cubit.dart';
import '../../blocs/video/video_state.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../widgets/video_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchCtrl = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Only fetch videos if we don't already have them loaded
    final currentState = context.read<VideoCubit>().state;
    if (currentState is VideoInitial) {
      context.read<VideoCubit>().fetchAllVideos();
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: AppColors.background,
            elevation: 0,
            title: _isSearching
                ? TextField(
                    controller: _searchCtrl,
                    autofocus: true,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      hintText: 'Search videos...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: AppColors.textSubtle),
                    ),
                    onSubmitted: (q) {
                      context.read<VideoCubit>().searchVideos(q);
                      setState(() => _isSearching = false);
                    },
                  )
                : ShaderMask(
                    shaderCallback: (b) => AppColors.primaryGradient.createShader(b),
                    child: const Text(
                      'LUME',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
            actions: [
              IconButton(
                icon: Icon(_isSearching ? Icons.close : Icons.search, color: AppColors.textPrimary),
                onPressed: () {
                  setState(() => _isSearching = !_isSearching);
                  if (!_isSearching) {
                    _searchCtrl.clear();
                    context.read<VideoCubit>().fetchAllVideos();
                  }
                },
              ),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state is AuthAuthenticated) {
                    return GestureDetector(
                      onTap: () => context.push('/profile'),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 14),
                        child: CircleAvatar(
                          radius: 16,
                          backgroundImage: state.user.avatar.isNotEmpty
                              ? NetworkImage(state.user.avatar)
                              : null,
                          backgroundColor: AppColors.primary,
                          child: state.user.avatar.isEmpty
                              ? Text(
                                  state.user.fullName[0].toUpperCase(),
                                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                )
                              : null,
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),

          // Category Chips
          SliverToBoxAdapter(
            child: SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: ['All', 'Gaming', 'Music', 'Tech', 'Vlogs', 'Sports', 'News'].map((c) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(c),
                      selected: c == 'All',
                      onSelected: (_) {},
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // Video Feed
          BlocBuilder<VideoCubit, VideoState>(
            builder: (context, state) {
              if (state is VideoLoading) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, __) => const VideoCardSkeleton(),
                    childCount: 5,
                  ),
                );
              }
              if (state is VideoError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.wifi_off, color: AppColors.textSubtle, size: 64),
                        const SizedBox(height: 16),
                        Text(state.message, style: const TextStyle(color: AppColors.textSecondary)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.read<VideoCubit>().fetchAllVideos(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (state is VideosLoaded) {
                if (state.videos.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.video_library_outlined, color: AppColors.textSubtle, size: 80),
                          SizedBox(height: 16),
                          Text('No videos yet', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                          SizedBox(height: 8),
                          Text('Be the first to upload!', style: TextStyle(color: AppColors.textSubtle)),
                        ],
                      ),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final video = state.videos[index];
                      return VideoCard(
                        video: video,
                        onTap: () => context.push('/video/${video.id}'),
                        onChannelTap: () => context.push('/channel/${video.owner?.username}'),
                      );
                    },
                    childCount: state.videos.length,
                  ),
                );
              }
              return const SliverFillRemaining(child: SizedBox());
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/upload-video'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.upload, color: Colors.white),
        label: const Text('Upload', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
