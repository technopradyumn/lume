// lib/core/constants/app_constants.dart

class AppConstants {
  AppConstants._();

  static const String appName = 'Lume';
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';
  // Use 10.0.2.2 for Android emulator (maps to localhost on host machine)
  // Use 10.39.53.121 (your machine's local IP) for physical device testing

  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String usernameKey = 'username';
}
