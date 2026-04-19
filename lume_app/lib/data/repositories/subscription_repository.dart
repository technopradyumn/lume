// lib/data/repositories/subscription_repository.dart
import '../../core/api/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/user_model.dart';

class SubscriptionRepository {
  final _dio = ApiClient().dio;

  Future<bool> toggleSubscription(String channelId) async {
    final response = await _dio.post(ApiEndpoints.channelSubscription(channelId));
    return response.data['data']['subscribed'] ?? false;
  }

  Future<List<UserModel>> getSubscribedChannels(String channelId) async {
    final response = await _dio.get(ApiEndpoints.channelSubscription(channelId));
    final list = response.data['data'] as List<dynamic>;
    return list.map((u) => UserModel.fromJson(u)).toList();
  }

  Future<List<UserModel>> getChannelSubscribers(String subscriberId) async {
    final response = await _dio.get(ApiEndpoints.userSubscribers(subscriberId));
    final list = response.data['data'] as List<dynamic>;
    return list.map((u) => UserModel.fromJson(u)).toList();
  }
}
