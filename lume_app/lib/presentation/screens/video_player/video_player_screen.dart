// lib/presentation/screens/video_player/video_player_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../../blocs/video/video_cubit.dart';
import '../../blocs/video/video_state.dart';
import '../../blocs/comment/comment_cubit.dart';
import '../../blocs/comment/comment_state.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/profile/profile_cubit.dart';
import '../../blocs/profile/profile_state.dart';
import '../../widgets/channel_avatar.dart';
import '../../widgets/comment_tile.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoId;
  const VideoPlayerScreen({super.key, required this.videoId});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  final _commentCtrl = TextEditingController();
  bool _isLiked = false;
  bool _showComments = false;

  @override
  void initState() {
    super.initState();
    // Only fetch video and comments if not already loaded
    final videoState = context.read<VideoCubit>().state;
    final commentState = context.read<CommentCubit>().state;
    
    if (videoState is VideoInitial || (videoState is VideoDetailLoaded && videoState.video.id != widget.videoId)) {
      context.read<VideoCubit>().fetchVideoById(widget.videoId);
    }
    
    if (commentState is CommentInitial) {
      context.read<CommentCubit>().fetchComments(widget.videoId);
    }
  }

  void _initPlayer(String url) {
    _videoController = VideoPlayerController.networkUrl(Uri.parse(url));
    _videoController!.initialize().then((_) {
      if (!mounted) return;
      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        aspectRatio: 16 / 9,
        placeholder: Container(color: AppColors.surface),
        materialProgressColors: ChewieProgressColors(
          playedColor: AppColors.primary,
          handleColor: AppColors.primary,
          bufferedColor: AppColors.primary.withOpacity(0.3),
          backgroundColor: AppColors.border,
        ),
      );
      setState(() {});
    });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    _commentCtrl.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<VideoCubit, VideoState>(
        listener: (context, state) {
          if (state is VideoDetailLoaded && _videoController == null) {
            _initPlayer(state.video.videoFile);
            setState(() => _isLiked = state.video.isLiked ?? false);
          }
        },
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              // Video Player
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Back button overlay
                    Container(
                      color: Colors.black,
                      child: SafeArea(
                        bottom: false,
                        child: Stack(
                          children: [
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: _chewieController != null
                                  ? Chewie(controller: _chewieController!)
                                  : Container(
                                      color: Colors.black,
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation(AppColors.primary),
                                        ),
                                      ),
                                    ),
                            ),
                            Positioned(
                              top: 8,
                              left: 8,
                              child: GestureDetector(
                                onTap: () => context.pop(),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if (state is VideoDetailLoaded) ...[
                // Video Info
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.video.title,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${DateFormatter.formatViewCount(state.video.views)} • ${state.video.createdAt != null ? DateFormatter.timeAgo(state.video.createdAt!) : ''}',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        ),
                        const SizedBox(height: 16),

                        // Action Row
                        Row(
                          children: [
                            _ActionButton(
                              icon: _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                              label: 'Like',
                              isActive: _isLiked,
                              onTap: () {
                                setState(() => _isLiked = !_isLiked);
                                context.read<VideoCubit>().toggleLike(state.video.id);
                              },
                            ),
                            const SizedBox(width: 8),
                            _ActionButton(
                              icon: Icons.comment_outlined,
                              label: 'Comments',
                              onTap: () => setState(() => _showComments = !_showComments),
                            ),
                            const Spacer(),
                            _ActionButton(
                              icon: Icons.share_outlined,
                              label: 'Share',
                              onTap: () {},
                            ),
                          ],
                        ),

                        const Divider(height: 24),

                        // Channel Info
                        Row(
                          children: [
                            ChannelAvatar(
                              imageUrl: state.video.owner?.avatar,
                              name: state.video.owner?.fullName ?? '',
                              size: 44,
                              onTap: () => context.push('/channel/${state.video.owner?.username}'),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.video.owner?.fullName ?? 'Unknown',
                                    style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '@${state.video.owner?.username ?? ''}',
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            BlocBuilder<ProfileCubit, ProfileState>(
                              builder: (context, profileState) {
                                return _SubscribeButton(
                                  channelId: state.video.owner?.id ?? '',
                                );
                              },
                            ),
                          ],
                        ),

                        const Divider(height: 24),

                        // Description
                        Text(
                          state.video.description,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.6),
                        ),
                      ],
                    ),
                  ),
                ),

                // Comments Section
                if (_showComments) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Text('Comments', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
                          const Spacer(),
                          BlocBuilder<CommentCubit, CommentState>(
                            builder: (_, s) => Text(
                              s is CommentsLoaded ? '${s.comments.length}' : '',
                              style: const TextStyle(color: AppColors.textSecondary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          BlocBuilder<AuthCubit, AuthState>(
                            builder: (_, s) => ChannelAvatar(
                              imageUrl: s is AuthAuthenticated ? s.user.avatar : null,
                              name: s is AuthAuthenticated ? s.user.fullName : '',
                              size: 36,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _commentCtrl,
                              style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                              decoration: InputDecoration(
                                hintText: 'Add a comment...',
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.send, color: AppColors.primary, size: 20),
                                  onPressed: () {
                                    if (_commentCtrl.text.isNotEmpty) {
                                      context.read<CommentCubit>().addComment(widget.videoId, _commentCtrl.text.trim());
                                      _commentCtrl.clear();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  BlocBuilder<CommentCubit, CommentState>(
                    builder: (context, state) {
                      if (state is CommentsLoaded) {
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => CommentTile(
                              comment: state.comments[index],
                              onLike: () => context.read<CommentCubit>().toggleLike(state.comments[index].id),
                              onDelete: () => context.read<CommentCubit>().deleteComment(state.comments[index].id, widget.videoId),
                            ),
                            childCount: state.comments.length,
                          ),
                        );
                      }
                      return const SliverToBoxAdapter(child: SizedBox());
                    },
                  ),
                ],
              ],
              const SliverToBoxAdapter(child: SizedBox(height: 60)),
            ],
          );
        },
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isActive;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withOpacity(0.15) : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: isActive ? AppColors.primary : AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.primary : AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubscribeButton extends StatelessWidget {
  final String channelId;
  const _SubscribeButton({required this.channelId});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => context.read<ProfileCubit>().toggleSubscription(channelId),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(0, 36),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      child: const Text('Subscribe', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
    );
  }
}
