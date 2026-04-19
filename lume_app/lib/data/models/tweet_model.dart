// lib/data/models/tweet_model.dart
import 'package:equatable/equatable.dart';
import 'user_model.dart';

class TweetModel extends Equatable {
  final String id;
  final String content;
  final UserModel? owner;
  final DateTime? createdAt;
  final bool? isLiked;
  final int? likesCount;

  const TweetModel({
    required this.id,
    required this.content,
    this.owner,
    this.createdAt,
    this.isLiked,
    this.likesCount,
  });

  factory TweetModel.fromJson(Map<String, dynamic> json) {
    return TweetModel(
      id: json['_id'] ?? '',
      content: json['content'] ?? '',
      owner: json['owner'] != null ? UserModel.fromJson(json['owner']) : null,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      isLiked: json['isLiked'],
      likesCount: json['likesCount'],
    );
  }

  @override
  List<Object?> get props => [id, content, isLiked];
}
