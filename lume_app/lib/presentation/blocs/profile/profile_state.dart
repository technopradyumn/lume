// lib/presentation/blocs/profile/profile_state.dart
import 'package:flutter/foundation.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/video_model.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}
class ProfileLoading extends ProfileState {}
class ProfileLoaded extends ProfileState {
  final UserModel profile;
  final List<VideoModel> videos;
  UserModel get user => profile;
  ProfileLoaded(this.profile, [this.videos = const []]);
}
class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
class ProfileUpdateSuccess extends ProfileState {}
