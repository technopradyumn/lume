// lib/data/repositories/playlist_repository.dart
import '../../core/api/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/playlist_model.dart';

class PlaylistRepository {
  final _dio = ApiClient().dio;

  Future<PlaylistModel> createPlaylist({
    required String name,
    required String description,
  }) async {
    final response = await _dio.post(ApiEndpoints.playlists,
        data: {'name': name, 'description': description});
    return PlaylistModel.fromJson(response.data['data']);
  }

  Future<PlaylistModel> getPlaylistById(String playlistId) async {
    final response = await _dio.get(ApiEndpoints.playlistById(playlistId));
    return PlaylistModel.fromJson(response.data['data']);
  }

  Future<List<PlaylistModel>> getUserPlaylists(String userId) async {
    final response = await _dio.get(ApiEndpoints.userPlaylists(userId));
    final list = response.data['data'] as List<dynamic>;
    return list.map((p) => PlaylistModel.fromJson(p)).toList();
  }

  Future<PlaylistModel> updatePlaylist({
    required String playlistId,
    required String name,
    required String description,
  }) async {
    final response = await _dio.patch(ApiEndpoints.playlistById(playlistId),
        data: {'name': name, 'description': description});
    return PlaylistModel.fromJson(response.data['data']);
  }

  Future<void> deletePlaylist(String playlistId) async {
    await _dio.delete(ApiEndpoints.playlistById(playlistId));
  }

  Future<void> addVideoToPlaylist(String videoId, String playlistId) async {
    await _dio.patch(ApiEndpoints.addVideoToPlaylist(videoId, playlistId));
  }

  Future<void> removeVideoFromPlaylist(String videoId, String playlistId) async {
    await _dio.patch(ApiEndpoints.removeVideoFromPlaylist(videoId, playlistId));
  }
}
