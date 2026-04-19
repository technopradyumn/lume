// lib/presentation/blocs/tweet/tweet_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/tweet_repository.dart';
import '../../../data/repositories/like_repository.dart';
import '../../../core/utils/error_handler.dart';
import 'tweet_state.dart';

class TweetCubit extends Cubit<TweetState> {
  final TweetRepository _tweetRepo;
  final LikeRepository _likeRepo;

  TweetCubit({
    required TweetRepository tweetRepository,
    required LikeRepository likeRepository,
  })  : _tweetRepo = tweetRepository,
        _likeRepo = likeRepository,
        super(TweetInitial());

  Future<void> fetchTweets(String userId) async {
    emit(TweetLoading());
    try {
      final tweets = await _tweetRepo.getUserTweets(userId);
      emit(TweetsLoaded(tweets));
    } catch (e) {
      emit(TweetError(extractErrorMessage(e)));
    }
  }

  Future<void> createTweet(String content, String userId) async {
    try {
      await _tweetRepo.createTweet(content);
      await fetchTweets(userId);
    } catch (e) {
      emit(TweetError(extractErrorMessage(e)));
    }
  }

  Future<void> updateTweet(String tweetId, String content, String userId) async {
    try {
      await _tweetRepo.updateTweet(tweetId, content);
      await fetchTweets(userId);
    } catch (e) {
      emit(TweetError(extractErrorMessage(e)));
    }
  }

  Future<void> deleteTweet(String tweetId, String userId) async {
    try {
      await _tweetRepo.deleteTweet(tweetId);
      await fetchTweets(userId);
    } catch (e) {
      emit(TweetError(extractErrorMessage(e)));
    }
  }

  Future<void> toggleLike(String tweetId) async {
    try {
      await _likeRepo.toggleTweetLike(tweetId);
    } catch (e) {
      emit(TweetError(extractErrorMessage(e)));
    }
  }
}
