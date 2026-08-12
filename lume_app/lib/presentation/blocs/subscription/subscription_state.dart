import 'package:flutter/foundation.dart';
import '../../../data/models/user_model.dart';

@immutable
abstract class SubscriptionState {}

class SubscriptionInitial extends SubscriptionState {}
class SubscriptionLoading extends SubscriptionState {}
class SubscriptionLoaded extends SubscriptionState {
  final List<UserModel> channels;
  SubscriptionLoaded(this.channels);
}
class SubscriptionError extends SubscriptionState {
  final String message;
  SubscriptionError(this.message);
}