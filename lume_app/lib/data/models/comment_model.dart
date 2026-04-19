// lib/data/models/comment_model.dart
import 'package:equatable/equatable.dart';
import 'user_model.dart';

class CommentModel extends Equatable {
  final String id;
  final String content;
  final String videoId;
  final UserModel? owner;
  final DateTime? createdAt;
  final bool? isLiked;
  final int? likesCount;

  const CommentModel({
    required this.id,
    required this.content,
    required this.videoId,
    this.owner,
    this.createdAt,
    this.isLiked,
    this.likesCount,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['_id'] ?? '',
      content: json['content'] ?? '',
      videoId: json['video'] ?? '',
      owner: json['owner'] != null ? UserModel.fromJson(json['owner']) : null,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      isLiked: json['isLiked'],
      likesCount: json['likesCount'],
    );
  }

  @override
  List<Object?> get props => [id, content, isLiked];
}
