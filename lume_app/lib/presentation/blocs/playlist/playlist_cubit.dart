// lib/presentation/blocs/playlist/playlist_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/playlist_repository.dart';
import '../../../core/utils/error_handler.dart';
import 'playlist_state.dart';

class PlaylistCubit extends Cubit<PlaylistState> {
  final PlaylistRepository _playlistRepo;

  PlaylistCubit({
    required PlaylistRepository playlistRepository,
  })  : _playlistRepo = playlistRepository,
        super(PlaylistInitial());

  Future<void> fetchPlaylist(String playlistId) async {
    emit(PlaylistLoading());
    try {
      final playlist = await _playlistRepo.getPlaylistById(playlistId);
      emit(PlaylistLoaded(playlist));
    } catch (e) {
      emit(PlaylistError(extractErrorMessage(e)));
    }
  }

  Future<void> fetchUserPlaylists(String userId) async {
    emit(PlaylistLoading());
    try {
      final playlists = await _playlistRepo.getUserPlaylists(userId);
      emit(PlaylistsLoaded(playlists));
    } catch (e) {
      emit(PlaylistError(extractErrorMessage(e)));
    }
  }

  Future<void> createPlaylist(String name, String description, String userId) async {
    try {
      await _playlistRepo.createPlaylist(name: name, description: description);
      await fetchUserPlaylists(userId);
    } catch (e) {
      emit(PlaylistError(extractErrorMessage(e)));
    }
  }

  Future<void> addVideoToPlaylist(String videoId, String playlistId) async {
    try {
      await _playlistRepo.addVideoToPlaylist(videoId, playlistId);
      await fetchPlaylist(playlistId);
    } catch (e) {
      emit(PlaylistError(extractErrorMessage(e)));
    }
  }

  Future<void> removeVideoFromPlaylist(String videoId, String playlistId) async {
    try {
      await _playlistRepo.removeVideoFromPlaylist(videoId, playlistId);
      await fetchPlaylist(playlistId);
    } catch (e) {
      emit(PlaylistError(extractErrorMessage(e)));
    }
  }

  Future<void> deletePlaylist(String playlistId, String userId) async {
    try {
      await _playlistRepo.deletePlaylist(playlistId);
      await fetchUserPlaylists(userId);
    } catch (e) {
      emit(PlaylistError(extractErrorMessage(e)));
    }
  }

  Future<void> updatePlaylist(String playlistId, String name, String description, String userId) async {
    try {
      await _playlistRepo.updatePlaylist(playlistId: playlistId, name: name, description: description);
      await fetchUserPlaylists(userId);
    } catch (e) {
      emit(PlaylistError(extractErrorMessage(e)));
    }
  }
}
