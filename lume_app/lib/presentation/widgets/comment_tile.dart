import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../core/theme/app_colors.dart';
import '../../data/models/comment_model.dart';
import 'channel_avatar.dart';

class CommentTile extends StatelessWidget {
  final CommentModel comment;
  final VoidCallback? onLike;

  const CommentTile({super.key, required this.comment, this.onLike});

  @override
  Widget build(BuildContext context) {
    final isLiked = comment.isLiked ?? false;
    final likesCount = comment.likesCount ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChannelAvatar(
            imageUrl: comment.owner?.avatar,
            name: comment.owner?.fullName ?? 'U',
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
                      comment.owner?.fullName ?? 'User',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      comment.createdAt != null ? timeago.format(comment.createdAt!) : '',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  comment.content,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: onLike,
                  child: Row(
                    children: [
                      Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        size: 14,
                        color: isLiked ? AppColors.danger : AppColors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$likesCount',
                        style: TextStyle(
                          fontSize: 11,
                          color: isLiked ? AppColors.danger : AppColors.textTertiary,
                        ),
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
