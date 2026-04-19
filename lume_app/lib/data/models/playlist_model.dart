// lib/data/models/playlist_model.dart
import 'package:equatable/equatable.dart';
import 'video_model.dart';

class PlaylistModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String ownerId;
  final List<VideoModel> videos;
  final DateTime? createdAt;

  const PlaylistModel({
    required this.id,
    required this.name,
    required this.description,
    required this.ownerId,
    this.videos = const [],
    this.createdAt,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      ownerId: json['owner'] is String ? json['owner'] : (json['owner']?['_id'] ?? ''),
      videos: (json['videos'] as List<dynamic>?)
              ?.map((v) => VideoModel.fromJson(v))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  String? get thumbnailUrl => videos.isNotEmpty ? videos.first.thumbnail : null;

  @override
  List<Object?> get props => [id, name, videos.length];
}
