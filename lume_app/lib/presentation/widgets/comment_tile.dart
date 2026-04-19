// lib/presentation/widgets/comment_tile.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../data/models/comment_model.dart';
import 'channel_avatar.dart';

class CommentTile extends StatelessWidget {
  final CommentModel comment;
  final bool isOwner;
  final VoidCallback? onLike;
  final VoidCallback? onDelete;

  const CommentTile({
    super.key,
    required this.comment,
    this.isOwner = false,
    this.onLike,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChannelAvatar(
            imageUrl: comment.owner?.avatar,
            name: comment.owner?.fullName ?? '',
            size: 32,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.owner?.fullName ?? 'Unknown',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      comment.createdAt != null ? DateFormatter.timeAgo(comment.createdAt!) : '',
                      style: const TextStyle(color: AppColors.textSubtle, fontSize: 11),
                    ),
                    const Spacer(),
                    if (isOwner)
                      GestureDetector(
                        onTap: onDelete,
                        child: const Icon(Icons.delete_outline, color: AppColors.error, size: 16),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.content,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: onLike,
                  child: Row(
                    children: [
                      Icon(
                        comment.isLiked == true ? Icons.thumb_up : Icons.thumb_up_outlined,
                        size: 14,
                        color: comment.isLiked == true ? AppColors.primary : AppColors.textSubtle,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${comment.likesCount ?? 0}',
                        style: const TextStyle(color: AppColors.textSubtle, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
