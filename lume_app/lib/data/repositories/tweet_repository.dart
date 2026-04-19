// lib/data/repositories/tweet_repository.dart
import '../../core/api/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/tweet_model.dart';

class TweetRepository {
  final _dio = ApiClient().dio;

  Future<TweetModel> createTweet(String content) async {
    final response = await _dio.post(ApiEndpoints.tweets, data: {'content': content});
    return TweetModel.fromJson(response.data['data']);
  }

  Future<List<TweetModel>> getUserTweets(String userId) async {
    final response = await _dio.get(ApiEndpoints.userTweets(userId));
    final list = response.data['data'] as List<dynamic>;
    return list.map((t) => TweetModel.fromJson(t)).toList();
  }

  Future<TweetModel> updateTweet(String tweetId, String content) async {
    final response = await _dio.patch(ApiEndpoints.tweetById(tweetId), data: {'content': content});
    return TweetModel.fromJson(response.data['data']);
  }

  Future<void> deleteTweet(String tweetId) async {
    await _dio.delete(ApiEndpoints.tweetById(tweetId));
  }
}
