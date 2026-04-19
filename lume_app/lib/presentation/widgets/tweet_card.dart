// lib/presentation/widgets/tweet_card.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../data/models/tweet_model.dart';
import 'channel_avatar.dart';

class TweetCard extends StatelessWidget {
  final TweetModel tweet;
  final bool isOwner;
  final VoidCallback? onLike;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onChannelTap;

  const TweetCard({
    super.key,
    required this.tweet,
    this.isOwner = false,
    this.onLike,
    this.onEdit,
    this.onDelete,
    this.onChannelTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ChannelAvatar(
                imageUrl: tweet.owner?.avatar,
                name: tweet.owner?.fullName ?? '',
                size: 38,
                onTap: onChannelTap,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tweet.owner?.fullName ?? 'Unknown',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      '@${tweet.owner?.username ?? ''} • ${tweet.createdAt != null ? DateFormatter.timeAgo(tweet.createdAt!) : ''}',
                      style: const TextStyle(
                        color: AppColors.textSubtle,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              if (isOwner)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_horiz, color: AppColors.textSecondary, size: 18),
                  color: AppColors.surfaceVariant,
                  onSelected: (v) {
                    if (v == 'edit') onEdit?.call();
                    if (v == 'delete') onDelete?.call();
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit', style: TextStyle(color: AppColors.textPrimary))),
                    const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: AppColors.error))),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            tweet.content,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
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
                      tweet.isLiked == true ? Icons.favorite : Icons.favorite_border,
                      color: tweet.isLiked == true ? AppColors.error : AppColors.textSubtle,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${tweet.likesCount ?? 0}',
                      style: const TextStyle(color: AppColors.textSubtle, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
