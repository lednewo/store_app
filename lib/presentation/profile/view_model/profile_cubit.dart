import 'package:base_app/domain/interfaces/auth_repository.dart';
import 'package:base_app/presentation/profile/view_model/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._authRepository) : super(const ProfileInitial());

  final AuthRepository _authRepository;

  Future<void> loadProfile() async {
    emit(const ProfileLoading());

    final result = await _authRepository.getProfile();

    result.when(
      ok: (profile) {
        if (profile != null) {
          emit(ProfileLoaded(profile: profile));
        } else {
          emit(const ProfileError('Profile not found.'));
        }
      },
      error: (e) => emit(ProfileError('Failed to load profile: $e')),
    );
  }

  Future<void> logout() async {
    final result = await _authRepository.logout();

    result.when(
      ok: (_) => emit(const ProfileLoggedOut()),
      error: (e) => emit(ProfileError('Failed to logout: $e')),
    );
  }
}
