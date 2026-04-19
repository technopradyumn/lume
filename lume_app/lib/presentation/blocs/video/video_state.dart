// lib/presentation/blocs/video/video_state.dart
import 'package:flutter/foundation.dart';
import '../../../data/models/video_model.dart';

@immutable
abstract class VideoState {}

class VideoInitial extends VideoState {}
class VideoLoading extends VideoState {}
class VideoDetailLoaded extends VideoState {
  final VideoModel video;
  VideoDetailLoaded(this.video);
}
class VideosLoaded extends VideoState {
  final List<VideoModel> videos;
  VideosLoaded(this.videos);
}
class VideoError extends VideoState {
  final String message;
  VideoError(this.message);
}
