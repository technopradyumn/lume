import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../blocs/tweet/tweet_cubit.dart';
import '../../blocs/tweet/tweet_state.dart';
import '../../widgets/tweet_card.dart';
import '../../widgets/shimmer_loader.dart';
import '../../widgets/empty_state.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final _tweetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<TweetCubit>().fetchTweets('');
  }

  @override
  void dispose() {
    _tweetController.dispose();
    super.dispose();
  }

  void _postTweet() {
    final text = _tweetController.text.trim();
    if (text.isNotEmpty) {
      context.read<TweetCubit>().createTweet(text, '');
      _tweetController.clear();
      Navigator.pop(context);
    }
  }

  void _showPostDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 16,
            left: 16,
            right: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'New Post',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textTertiary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _tweetController,
                maxLines: 4,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: "What's on your mind?",
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _postTweet,
                  child: const Text('Post'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: const Text('Community'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showPostDialog,
        backgroundColor: AppColors.accentStart,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      body: BlocBuilder<TweetCubit, TweetState>(
        builder: (context, state) {
          if (state is TweetLoading) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, __) => const ShimmerLoader(height: 120),
            );
          } else if (state is TweetsLoaded) {
            if (state.tweets.isEmpty) {
              return const EmptyStateWidget(
                icon: Icons.chat_bubble_outline,
                title: 'No community posts yet',
                description: 'Tap the button below to start a conversation.',
              );
            }
            return RefreshIndicator(
              onRefresh: () async => context.read<TweetCubit>().fetchTweets(''),
              color: AppColors.accentStart,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.tweets.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final tweet = state.tweets[index];
                  return TweetCard(
                    tweet: tweet,
                    onLike: () => context.read<TweetCubit>().toggleLike(tweet.id),
                  );
                },
              ),
            );
          } else if (state is TweetError) {
            return Center(child: Text(state.message, style: const TextStyle(color: AppColors.danger)));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
