// lib/data/repositories/comment_repository.dart
import '../../core/api/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/comment_model.dart';

class CommentRepository {
  final _dio = ApiClient().dio;

  Future<List<CommentModel>> getVideoComments(String videoId) async {
    final response = await _dio.get(ApiEndpoints.videoComments(videoId));
    final data = response.data['data'];
    final list = data is List ? data : (data['docs'] as List<dynamic>? ?? []);
    return list.map((c) => CommentModel.fromJson(c)).toList();
  }

  Future<CommentModel> addComment({
    required String videoId,
    required String content,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.videoComments(videoId),
      data: {'content': content},
    );
    return CommentModel.fromJson(response.data['data']);
  }

  Future<CommentModel> updateComment(String commentId, String content) async {
    final response = await _dio.patch(
      ApiEndpoints.commentById(commentId),
      data: {'content': content},
    );
    return CommentModel.fromJson(response.data['data']);
  }

  Future<void> deleteComment(String commentId) async {
    await _dio.delete(ApiEndpoints.commentById(commentId));
  }
}
