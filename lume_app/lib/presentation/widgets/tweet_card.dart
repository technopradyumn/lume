import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../core/theme/app_colors.dart';
import '../../data/models/tweet_model.dart';
import 'channel_avatar.dart';

class TweetCard extends StatelessWidget {
  final TweetModel tweet;
  final VoidCallback? onLike;
  final VoidCallback? onDelete;
  final bool isOwner;

  const TweetCard({
    super.key,
    required this.tweet,
    this.onLike,
    this.onDelete,
    this.isOwner = false,
  });

  @override
  Widget build(BuildContext context) {
    final isLiked = tweet.isLiked ?? false;
    final likesCount = tweet.likesCount ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ChannelAvatar(
                imageUrl: tweet.owner?.avatar,
                name: tweet.owner?.fullName ?? 'U',
                size: 36,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tweet.owner?.fullName ?? 'User',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '@${tweet.owner?.username ?? "user"} • ${tweet.createdAt != null ? timeago.format(tweet.createdAt!) : ""}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              if (isOwner)
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.danger),
                  onPressed: onDelete,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            tweet.content,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              GestureDetector(
                onTap: onLike,
                child: Row(
                  children: [
                    Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      size: 16,
                      color: isLiked ? AppColors.danger : AppColors.textTertiary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$likesCount',
                      style: TextStyle(
                        fontSize: 12,
                        color: isLiked ? AppColors.danger : AppColors.textTertiary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Row(
                children: const [
                  Icon(Icons.chat_bubble_outline, size: 16, color: AppColors.textTertiary),
                  SizedBox(width: 6),
                  Text(
                    'Reply',
                    style: TextStyle(fontSize: 12, color: AppColors.textTertiary, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
