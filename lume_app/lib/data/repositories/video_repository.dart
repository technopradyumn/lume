// lib/data/repositories/video_repository.dart
import 'package:dio/dio.dart';
import '../../core/api/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/video_model.dart';

class VideoRepository {
  final _dio = ApiClient().dio;

  Future<List<VideoModel>> getAllVideos({
    int page = 1,
    int limit = 10,
    String? query,
    String? sortBy,
    String? sortType,
    String? userId,
  }) async {
    final response = await _dio.get(ApiEndpoints.videos, queryParameters: {
      'page': page,
      'limit': limit,
      if (query != null) 'query': query,
      if (sortBy != null) 'sortBy': sortBy,
      if (sortType != null) 'sortType': sortType,
      if (userId != null) 'userId': userId,
    });

    final data = response.data['data'];
    if (data is List) {
      return data.map((v) => VideoModel.fromJson(v)).toList();
    }
    // If paginated response
    final docs = data['docs'] as List<dynamic>? ?? [];
    return docs.map((v) => VideoModel.fromJson(v)).toList();
  }

  Future<VideoModel> getVideoById(String videoId) async {
    final response = await _dio.get(ApiEndpoints.videoById(videoId));
    return VideoModel.fromJson(response.data['data']);
  }

  Future<VideoModel> publishVideo({
    required String title,
    required String description,
    required String videoPath,
    required String thumbnailPath,
  }) async {
    final formData = FormData.fromMap({
      'title': title,
      'description': description,
      'videoFile': await MultipartFile.fromFile(videoPath, filename: 'video.mp4'),
      'thumbnail': await MultipartFile.fromFile(thumbnailPath, filename: 'thumbnail.jpg'),
    });
    final response = await _dio.post(
      ApiEndpoints.videos,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    return VideoModel.fromJson(response.data['data']);
  }

  Future<VideoModel> updateVideo({
    required String videoId,
    required String title,
    required String description,
    String? thumbnailPath,
  }) async {
    final formData = FormData.fromMap({
      'title': title,
      'description': description,
      if (thumbnailPath != null)
        'thumbnail': await MultipartFile.fromFile(thumbnailPath, filename: 'thumbnail.jpg'),
    });
    final response = await _dio.patch(
      ApiEndpoints.updateVideo(videoId),
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    return VideoModel.fromJson(response.data['data']);
  }

  Future<void> deleteVideo(String videoId) async {
    await _dio.delete(ApiEndpoints.deleteVideo(videoId));
  }

  Future<bool> togglePublish(String videoId) async {
    final response = await _dio.patch(ApiEndpoints.togglePublish(videoId));
    return response.data['data']['isPublished'] ?? false;
  }
}
