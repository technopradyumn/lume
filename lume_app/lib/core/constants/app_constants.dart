// lib/core/constants/app_constants.dart

import 'dart:io';

class AppConstants {
  AppConstants._();

  static const String appName = 'Lume';

  static String get baseUrl {
    if (Platform.isAndroid) {
      // Android emulator: maps to host localhost
      return 'http://10.0.2.2:8000/api/v1';
    }

    // iOS simulator or desktop/mobile debug: local host
    return 'http://127.0.0.1:8000/api/v1';
  }

  // For a real physical Android device, replace with your PC's LAN IP:
  // static const String localDeviceUrl = 'http://10.153.158.121:8000/api/v1';

  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String usernameKey = 'username';
}
