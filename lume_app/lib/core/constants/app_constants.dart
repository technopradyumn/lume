
import 'dart:io';

class AppConstants {
  AppConstants._();

  static const String appName = 'Lume';

  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api/v1';
    }

    return 'http://127.0.0.1:8000/api/v1';
  }


  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String usernameKey = 'username';
}
