// lib/presentation/screens/channel_profile/channel_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../../blocs/profile/profile_cubit.dart';
import '../../blocs/profile/profile_state.dart';
import '../../blocs/video/video_cubit.dart';
import '../../blocs/video/video_state.dart';
import '../../widgets/channel_avatar.dart';
import '../../widgets/video_card.dart';

class ChannelProfileScreen extends StatefulWidget {
  final String username;
  const ChannelProfileScreen({super.key, required this.username});

  @override
  State<ChannelProfileScreen> createState() => _ChannelProfileScreenState();
}

class _ChannelProfileScreenState extends State<ChannelProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Only fetch profile if not already loaded or if it's a different user
    final currentState = context.read<ProfileCubit>().state;
    if (currentState is ProfileInitial || (currentState is ProfileLoaded && currentState.user.username != widget.username)) {
      context.read<ProfileCubit>().fetchProfile(widget.username);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(AppColors.primary)));
          }
          if (state is ProfileError) {
            return Center(child: Text(state.message, style: const TextStyle(color: AppColors.error)));
          }
          if (state is! ProfileLoaded) return const SizedBox();

          final user = state.user;
          return CustomScrollView(
            slivers: [
              // Cover + Back
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: AppColors.background,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: user.coverImage != null && user.coverImage!.isNotEmpty
                      ? CachedNetworkImage(imageUrl: user.coverImage!, fit: BoxFit.cover)
                      : Container(
                          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                        ),
                ),
              ),

              // Profile Info
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ChannelAvatar(
                            imageUrl: user.avatar,
                            name: user.fullName,
                            size: 72,
                            showBorder: true,
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () => context.read<ProfileCubit>().toggleSubscription(user.id),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: user.isSubscribed == true ? AppColors.surfaceVariant : AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                            child: Text(user.isSubscribed == true ? 'Subscribed ✓' : 'Subscribe'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(user.fullName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
                      Text('@${user.username}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _Stat(label: 'Subscribers', value: DateFormatter.formatSubscriberCount(user.subscribersCount ?? 0).split(' ')[0]),
                          const SizedBox(width: 24),
                          _Stat(label: 'Subscriptions', value: '${user.channelsSubscribedToCount ?? 0}'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
                      const Text('Videos', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),

              // Channel Videos
              BlocBuilder<VideoCubit, VideoState>(
                builder: (context, videoState) {
                  if (videoState is VideoLoading) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate((_, __) => const VideoCardSkeleton(), childCount: 3),
                    );
                  }
                  if (videoState is VideosLoaded) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => VideoCard(
                          video: videoState.videos[i],
                          onTap: () => context.push('/video/${videoState.videos[i].id}'),
                        ),
                        childCount: videoState.videos.length,
                      ),
                    );
                  }
                  return const SliverToBoxAdapter(child: SizedBox());
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 60)),
            ],
          );
        },
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ],
    );
  }
}
