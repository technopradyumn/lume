// lib/data/models/video_model.dart
import 'package:equatable/equatable.dart';
import 'user_model.dart';

class VideoModel extends Equatable {
  final String id;
  final String videoFile;
  final String thumbnail;
  final String title;
  final String description;
  final double duration;
  final int views;
  final bool isPublished;
  final UserModel? owner;
  final DateTime? createdAt;
  final bool? isLiked;
  final int? likesCount;

  const VideoModel({
    required this.id,
    required this.videoFile,
    required this.thumbnail,
    required this.title,
    required this.description,
    required this.duration,
    required this.views,
    required this.isPublished,
    this.owner,
    this.createdAt,
    this.isLiked,
    this.likesCount,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['_id'] ?? '',
      videoFile: json['videoFile'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      duration: (json['duration'] ?? 0).toDouble(),
      views: json['views'] ?? 0,
      isPublished: json['isPublished'] ?? true,
      owner: json['owner'] != null ? UserModel.fromJson(json['owner']) : null,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      isLiked: json['isLiked'],
      likesCount: json['likesCount'],
    );
  }

  String get durationFormatted {
    final d = Duration(seconds: duration.toInt());
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  List<Object?> get props => [id, title, views, isLiked];
}
