// lib/presentation/blocs/video/video_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/video_repository.dart';
import '../../../data/repositories/like_repository.dart';
import '../../../core/utils/error_handler.dart';
import 'video_state.dart';

class VideoCubit extends Cubit<VideoState> {
  final VideoRepository _videoRepo;
  final LikeRepository _likeRepo;

  VideoCubit({
    required VideoRepository videoRepository,
    required LikeRepository likeRepository,
  })  : _videoRepo = videoRepository,
        _likeRepo = likeRepository,
        super(VideoInitial());

  Future<void> fetchVideoById(String videoId) async {
    emit(VideoLoading());
    try {
      final video = await _videoRepo.getVideoById(videoId);
      emit(VideoDetailLoaded(video));
    } catch (e) {
      emit(VideoError(extractErrorMessage(e)));
    }
  }

  Future<void> fetchAllVideos() async {
    emit(VideoLoading());
    try {
      final videos = await _videoRepo.getAllVideos(page: 1, limit: 10);
      emit(VideosLoaded(videos));
    } catch (e) {
      emit(VideoError(extractErrorMessage(e)));
    }
  }

  Future<void> searchVideos(String query) async {
    emit(VideoLoading());
    try {
      final videos = await _videoRepo.getAllVideos(page: 1, limit: 10, query: query);
      emit(VideosLoaded(videos));
    } catch (e) {
      emit(VideoError(extractErrorMessage(e)));
    }
  }

  Future<void> togglePublish(String videoId) async {
    try {
      await _videoRepo.togglePublish(videoId);
    } catch (e) {
      emit(VideoError(extractErrorMessage(e)));
    }
  }

  Future<void> deleteVideo(String videoId) async {
    try {
      await _videoRepo.deleteVideo(videoId);
    } catch (e) {
      emit(VideoError(extractErrorMessage(e)));
    }
  }

  Future<void> toggleLike(String videoId) async {
    try {
      await _likeRepo.toggleVideoLike(videoId);
    } catch (e) {
      emit(VideoError(extractErrorMessage(e)));
    }
  }

  Future<void> getLikedVideos() async {
    emit(VideoLoading());
    try {
      final videos = await _likeRepo.getLikedVideos();
      emit(VideosLoaded(videos));
    } catch (e) {
      emit(VideoError(extractErrorMessage(e)));
    }
  }
}
