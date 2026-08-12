import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import '../../../core/theme/app_colors.dart';
import '../../blocs/comment/comment_cubit.dart';
import '../../blocs/comment/comment_state.dart';
import '../../widgets/channel_avatar.dart';
import '../../widgets/comment_tile.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoId;

  const VideoPlayerScreen({super.key, required this.videoId});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initPlayer();
    context.read<CommentCubit>().fetchComments(widget.videoId);
  }

  void _initPlayer() {
    _controller = VideoPlayerController.networkUrl(
      Uri.parse('https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'),
    )..initialize().then((_) {
        setState(() {});
        _controller?.play();
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _addComment() {
    final text = _commentController.text.trim();
    if (text.isNotEmpty) {
      context.read<CommentCubit>().addComment(widget.videoId, text);
      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Colors.black,
                child: _controller != null && _controller!.value.isInitialized
                    ? Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          VideoPlayer(_controller!),
                          VideoProgressIndicator(_controller!, allowScrubbing: true),
                        ],
                      )
                    : const Center(child: CircularProgressIndicator(color: AppColors.accentStart)),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Building a Full-Stack App with Next.js 15',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '184.2K views • 2 days ago',
                    style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const ChannelAvatar(name: 'Code Architect', size: 40),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Code Architect', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                            Text('45.6K subs', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text('Subscribe'),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  const Text('Comments', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          style: const TextStyle(fontSize: 13),
                          decoration: const InputDecoration(
                            hintText: 'Add a comment...',
                            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.send, color: AppColors.accentGlow),
                        onPressed: _addComment,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<CommentCubit, CommentState>(
                    builder: (context, state) {
                      if (state is CommentsLoaded) {
                        return Column(
                          children: state.comments.map((c) => CommentTile(comment: c)).toList(),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
