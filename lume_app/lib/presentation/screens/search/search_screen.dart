import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../blocs/video/video_cubit.dart';
import '../../blocs/video/video_state.dart';
import '../../widgets/lume_search_bar.dart';
import '../../widgets/video_card.dart';
import '../../widgets/shimmer_loader.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: LumeSearchBar(
            onSubmitted: (query) {
              context.read<VideoCubit>().searchVideos(query);
            },
          ),
        ),
      ),
      body: BlocBuilder<VideoCubit, VideoState>(
        builder: (context, state) {
          if (state is VideoLoading) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, __) => const ShimmerLoader(height: 220),
            );
          } else if (state is VideosLoaded) {
            return ListView.separated(
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
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
