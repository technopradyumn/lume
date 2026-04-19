// lib/presentation/screens/tweets/tweets_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../blocs/tweet/tweet_cubit.dart';
import '../../blocs/tweet/tweet_state.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../widgets/tweet_card.dart';
import '../../widgets/channel_avatar.dart';

class TweetsScreen extends StatefulWidget {
  const TweetsScreen({super.key});

  @override
  State<TweetsScreen> createState() => _TweetsScreenState();
}

class _TweetsScreenState extends State<TweetsScreen> {
  final _ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      context.read<TweetCubit>().fetchTweets(authState.user.id);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final currentUser = authState is AuthAuthenticated ? authState.user : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: Column(
        children: [
          // Compose Box
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ChannelAvatar(
                  imageUrl: currentUser?.avatar,
                  name: currentUser?.fullName ?? '',
                  size: 36,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    children: [
                      TextField(
                        controller: _ctrl,
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                        maxLines: 3,
                        minLines: 1,
                        decoration: const InputDecoration(
                          hintText: "What's on your mind?",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (_ctrl.text.isNotEmpty && currentUser != null) {
                                context.read<TweetCubit>().createTweet(_ctrl.text.trim(), currentUser.id);
                                _ctrl.clear();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(0, 32),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: const Text('Post'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Tweets List
          Expanded(
            child: BlocBuilder<TweetCubit, TweetState>(
              builder: (context, state) {
                if (state is TweetLoading) {
                  return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(AppColors.primary)));
                }
                if (state is TweetsLoaded) {
                  if (state.tweets.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit_note, color: AppColors.textSubtle, size: 72),
                          SizedBox(height: 12),
                          Text('No posts yet', style: TextStyle(color: AppColors.textSecondary)),
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () async {
                      if (currentUser != null) {
                        context.read<TweetCubit>().fetchTweets(currentUser.id);
                      }
                    },
                    child: ListView.builder(
                      itemCount: state.tweets.length,
                      itemBuilder: (context, i) {
                        final tweet = state.tweets[i];
                        return TweetCard(
                          tweet: tweet,
                          isOwner: tweet.owner?.id == currentUser?.id,
                          onLike: () => context.read<TweetCubit>().toggleLike(tweet.id),
                          onDelete: () {
                            if (currentUser != null) {
                              context.read<TweetCubit>().deleteTweet(tweet.id, currentUser.id);
                            }
                          },
                          onEdit: () => _showEditDialog(context, tweet.id, tweet.content, currentUser?.id ?? ''),
                        );
                      },
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

  void _showEditDialog(BuildContext context, String tweetId, String content, String userId) {
    final ctrl = TextEditingController(text: content);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Edit Post', style: TextStyle(color: AppColors.textPrimary)),
        content: TextField(
          controller: ctrl,
          style: const TextStyle(color: AppColors.textPrimary),
          maxLines: 4,
          decoration: const InputDecoration(labelText: 'Content'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              context.read<TweetCubit>().updateTweet(tweetId, ctrl.text, userId);
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
