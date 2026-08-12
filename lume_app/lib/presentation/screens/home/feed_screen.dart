import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../blocs/video/video_cubit.dart';
import '../../blocs/video/video_state.dart';
import '../../widgets/category_pills.dart';
import '../../widgets/video_card.dart';
import '../../widgets/shimmer_loader.dart';
import '../../widgets/empty_state.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All', 'Coding', 'Design', 'Gaming', 'AI & Tech', 'Music', 'Vlogs'
  ];

  @override
  void initState() {
    super.initState();
    context.read<VideoCubit>().fetchAllVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: AppColors.accentGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            ShaderMask(
              shaderCallback: (bounds) => AppColors.accentGradient.createShader(bounds),
              child: const Text(
                'Lume',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: AppColors.textPrimary),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.accentGlow),
            onPressed: () => context.push('/upload'),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          CategoryPills(
            categories: _categories,
            selected: _selectedCategory,
            onSelect: (cat) {
              setState(() => _selectedCategory = cat);
              if (cat == 'All') {
                context.read<VideoCubit>().fetchAllVideos();
              } else {
                context.read<VideoCubit>().searchVideos(cat);
              }
            },
          ),
          const SizedBox(height: 12),
          Expanded(
            child: BlocBuilder<VideoCubit, VideoState>(
              builder: (context, state) {
                if (state is VideoLoading) {
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: 4,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (_, __) => const ShimmerLoader(height: 220),
                  );
                } else if (state is VideosLoaded) {
                  if (state.videos.isEmpty) {
                    return const EmptyStateWidget(
                      icon: Icons.video_library_outlined,
                      title: 'No videos found',
                      description: 'Try checking back later or searching for something else.',
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<VideoCubit>().fetchAllVideos();
                    },
                    color: AppColors.accentStart,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.videos.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final video = state.videos[index];
                        return VideoCard(
                          video: video,
                          onTap: () => context.push('/watch/${video.id}'),
                        );
                      },
                    ),
                  );
                } else if (state is VideoError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.message, style: const TextStyle(color: AppColors.danger)),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => context.read<VideoCubit>().fetchAllVideos(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
