// lib/data/repositories/user_repository.dart
import 'package:dio/dio.dart';
import '../../core/api/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/user_model.dart';
import '../models/video_model.dart';

class UserRepository {
  final _dio = ApiClient().dio;

  Future<UserModel> getCurrentUser() async {
    final response = await _dio.get(ApiEndpoints.currentUser);
    return UserModel.fromJson(response.data['data']);
  }

  Future<UserModel> updateAccountDetails({
    required String fullName,
    required String email,
  }) async {
    final response = await _dio.patch(ApiEndpoints.updateAccount, data: {
      'fullName': fullName,
      'email': email,
    });
    return UserModel.fromJson(response.data['data']);
  }

  Future<UserModel> updateAvatar(String imagePath) async {
    final formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(imagePath, filename: 'avatar.jpg'),
    });
    final response = await _dio.patch(
      ApiEndpoints.updateAvatar,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    return UserModel.fromJson(response.data['data']);
  }

  Future<UserModel> updateCoverImage(String imagePath) async {
    final formData = FormData.fromMap({
      'coverImage': await MultipartFile.fromFile(imagePath, filename: 'cover.jpg'),
    });
    final response = await _dio.patch(
      ApiEndpoints.updateCoverImage,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    return UserModel.fromJson(response.data['data']);
  }

  Future<UserModel> getChannelProfile(String username) async {
    final response = await _dio.get(ApiEndpoints.channelProfile(username));
    return UserModel.fromJson(response.data['data']);
  }

  Future<List<VideoModel>> getWatchHistory() async {
    final response = await _dio.get(ApiEndpoints.watchHistory);
    final list = response.data['data'] as List<dynamic>;
    return list.map((v) => VideoModel.fromJson(v)).toList();
  }
}
