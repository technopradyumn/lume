// lib/data/repositories/auth_repository.dart
import 'package:dio/dio.dart';
import '../../core/api/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/storage/secure_storage.dart';
import '../models/user_model.dart';

class AuthRepository {
  final _dio = ApiClient().dio;
  final _storage = SecureStorage();

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String username,
    required String password,
    String? avatarPath,
    String? coverImagePath,
  }) async {
    final formData = FormData.fromMap({
      'fullName': fullName,
      'email': email,
      'username': username,
      'password': password,
      if (avatarPath != null)
        'avatar': await MultipartFile.fromFile(avatarPath, filename: 'avatar.jpg'),
      if (coverImagePath != null)
        'coverImage': await MultipartFile.fromFile(coverImagePath, filename: 'cover.jpg'),
    });

    final response = await _dio.post(
      ApiEndpoints.register,
      data: formData,
    );
    return response.data;
  }

  Future<UserModel> login({
    required String emailOrUsername,
    required String password,
  }) async {
    final isEmail = emailOrUsername.contains('@');
    final response = await _dio.post(ApiEndpoints.login, data: {
      if (isEmail) 'email': emailOrUsername else 'username': emailOrUsername,
      'password': password,
    });

    final data = response.data['data'];
    final user = UserModel.fromJson(data['user']);
    await _storage.saveTokens(
      accessToken: data['accessToken'],
      refreshToken: data['refreshToken'],
    );
    await _storage.saveUserId(user.id);
    await _storage.saveUsername(user.username);
    return user;
  }

  Future<void> logout() async {
    try {
      await _dio.post(ApiEndpoints.logout);
    } finally {
      await _storage.clearAll();
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await _dio.post(ApiEndpoints.changePassword, data: {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    });
  }

  Future<UserModel> getCurrentUser() async {
    final response = await _dio.get(ApiEndpoints.currentUser);
    return UserModel.fromJson(response.data['data']);
  }

  Future<bool> hasSession() => _storage.hasValidSession();
}
