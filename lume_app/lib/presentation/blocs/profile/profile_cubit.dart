// lib/presentation/blocs/profile/profile_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/repositories/subscription_repository.dart';
import '../../../core/utils/error_handler.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserRepository _userRepo;
  final SubscriptionRepository _subscriptionRepo;

  ProfileCubit({
    required UserRepository userRepository,
    required SubscriptionRepository subscriptionRepository,
  })  : _userRepo = userRepository,
        _subscriptionRepo = subscriptionRepository,
        super(ProfileInitial());

  Future<void> fetchProfile(String username) async {
    emit(ProfileLoading());
    try {
      final profile = await _userRepo.getChannelProfile(username);
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(extractErrorMessage(e)));
    }
  }

  Future<void> fetchCurrentUser() async {
    emit(ProfileLoading());
    try {
      final user = await _userRepo.getCurrentUser();
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(extractErrorMessage(e)));
    }
  }

  Future<void> updateAccountDetails({required String fullName, required String email}) async {
    emit(ProfileLoading());
    try {
      final user = await _userRepo.updateAccountDetails(
        fullName: fullName,
        email: email,
      );
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(extractErrorMessage(e)));
    }
  }

  Future<void> updateAvatar(String imagePath) async {
    emit(ProfileLoading());
    try {
      final user = await _userRepo.updateAvatar(imagePath);
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(extractErrorMessage(e)));
    }
  }

  Future<void> updateCoverImage(String imagePath) async {
    emit(ProfileLoading());
    try {
      final user = await _userRepo.updateCoverImage(imagePath);
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(extractErrorMessage(e)));
    }
  }

  Future<void> toggleSubscription(String channelId) async {
    try {
      await _subscriptionRepo.toggleSubscription(channelId);
      // Optionally refresh profile if needed
    } catch (e) {
      emit(ProfileError(extractErrorMessage(e)));
    }
  }
}
