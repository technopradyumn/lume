// lib/data/repositories/dashboard_repository.dart
import '../../core/api/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/dashboard_model.dart';
import '../models/video_model.dart';

class DashboardRepository {
  final _dio = ApiClient().dio;

  Future<DashboardStatsModel> getChannelStats() async {
    final response = await _dio.get(ApiEndpoints.channelStats);
    return DashboardStatsModel.fromJson(response.data['data'] ?? {});
  }

  Future<List<VideoModel>> getChannelVideos() async {
    final response = await _dio.get(ApiEndpoints.channelVideos);
    final list = response.data['data'] as List<dynamic>? ?? [];
    return list.map((v) => VideoModel.fromJson(v)).toList();
  }
}
