// lib/presentation/blocs/auth/auth_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../core/utils/error_handler.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepo;

  AuthCubit({required AuthRepository authRepository}) 
      : _authRepo = authRepository, 
        super(AuthInitial());

  Future<void> checkSession() async {
    emit(AuthLoading());
    try {
      final user = await _authRepo.getCurrentUser();
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> login(String emailOrUsername, String password) async {
    emit(AuthLoading());
    try {
      final user = await _authRepo.login(
        emailOrUsername: emailOrUsername,
        password: password,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(extractErrorMessage(e)));
    }
  }

  Future<void> changePassword({required String oldPassword, required String newPassword}) async {
    try {
      await _authRepo.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
    } catch (e) {
      emit(AuthError(extractErrorMessage(e)));
    }
  }

  Future<void> register({
    required String email,
    required String username,
    required String password,
    required String fullName,
    String? avatarPath,
    String? coverImagePath,
  }) async {
    emit(AuthLoading());
    try {
      await _authRepo.register(
        fullName: fullName,
        email: email,
        username: username,
        password: password,
        avatarPath: avatarPath,
        coverImagePath: coverImagePath,
      );
      final user = await _authRepo.login(
        emailOrUsername: email,
        password: password,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(extractErrorMessage(e)));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await _authRepo.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(extractErrorMessage(e)));
    }
  }
}
