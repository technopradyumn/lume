// lib/presentation/blocs/tweet/tweet_state.dart
import 'package:flutter/foundation.dart';
import '../../../data/models/tweet_model.dart';

@immutable
abstract class TweetState {}

class TweetInitial extends TweetState {}
class TweetLoading extends TweetState {}
class TweetsLoaded extends TweetState {
  final List<TweetModel> tweets;
  TweetsLoaded(this.tweets);
}
class TweetError extends TweetState {
  final String message;
  TweetError(this.message);
}
