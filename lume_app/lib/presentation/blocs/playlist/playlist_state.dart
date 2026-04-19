// lib/presentation/blocs/playlist/playlist_state.dart
import 'package:flutter/foundation.dart';
import '../../../data/models/playlist_model.dart';

@immutable
abstract class PlaylistState {}

class PlaylistInitial extends PlaylistState {}
class PlaylistLoading extends PlaylistState {}
class PlaylistLoaded extends PlaylistState {
  final PlaylistModel playlist;
  PlaylistLoaded(this.playlist);
}
class PlaylistsLoaded extends PlaylistState {
  final List<PlaylistModel> playlists;
  PlaylistsLoaded(this.playlists);
}
class PlaylistError extends PlaylistState {
  final String message;
  PlaylistError(this.message);
}