// lib/presentation/blocs/subscription/subscription_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/subscription_repository.dart';
import '../../../core/utils/error_handler.dart';
import 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final SubscriptionRepository _subscriptionRepo;

  SubscriptionCubit({
    required SubscriptionRepository subscriptionRepository,
  })  : _subscriptionRepo = subscriptionRepository,
        super(SubscriptionInitial());

  Future<void> toggleSubscription(String channelId) async {
    try {
      await _subscriptionRepo.toggleSubscription(channelId);
      // Refresh list or state if needed
    } catch (e) {
      emit(SubscriptionError(extractErrorMessage(e)));
    }
  }

  Future<void> fetchSubscribedChannels(String subscriberId) async {
    emit(SubscriptionLoading());
    try {
      final channels = await _subscriptionRepo.getSubscribedChannels(subscriberId);
      emit(SubscriptionLoaded(channels));
    } catch (e) {
      emit(SubscriptionError(extractErrorMessage(e)));
    }
  }
}
