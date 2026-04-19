import 'package:dio/dio.dart';

String extractErrorMessage(dynamic error) {
  if (error is DioException) {
    if (error.response != null) {
      final data = error.response!.data;
      if (data is Map<String, dynamic>) {
        return data['message'] ?? data['error'] ?? 'An error occurred';
      }
      return error.response!.statusMessage ?? 'An error occurred';
    } else {
      return error.message ?? 'Network error';
    }
  } else if (error is Exception) {
    return error.toString();
  } else {
    return 'Unknown error';
  }
}
