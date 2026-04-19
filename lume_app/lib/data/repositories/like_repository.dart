// lib/data/repositories/like_repository.dart
import '../../core/api/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/video_model.dart';

class LikeRepository {
  final _dio = ApiClient().dio;

  Future<bool> toggleVideoLike(String videoId) async {
    final response = await _dio.post(ApiEndpoints.toggleVideoLike(videoId));
    return response.data['data']['isLiked'] ?? false;
  }

  Future<bool> toggleCommentLike(String commentId) async {
    final response = await _dio.post(ApiEndpoints.toggleCommentLike(commentId));
    return response.data['data']['isLiked'] ?? false;
  }

  Future<bool> toggleTweetLike(String tweetId) async {
    final response = await _dio.post(ApiEndpoints.toggleTweetLike(tweetId));
    return response.data['data']['isLiked'] ?? false;
  }

  Future<List<VideoModel>> getLikedVideos() async {
    final response = await _dio.get(ApiEndpoints.likedVideos);
    final list = response.data['data'] as List<dynamic>;
    return list.map((v) => VideoModel.fromJson(v)).toList();
  }
}
