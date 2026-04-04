import 'package:base_app/domain/dto/profile_dto.dart';
import 'package:base_app/domain/interfaces/auth_repository.dart';
import 'package:base_app/domain/interfaces/profile_repository.dart';
import 'package:base_app/presentation/profile/view_model/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._profileRepository, this._authRepository)
    : super(const ProfileInitial());

  final ProfileRepository _profileRepository;
  final AuthRepository _authRepository;

  Future<void> loadProfile() async {
    emit(const ProfileLoading());

    final result = await _profileRepository.getProfile();

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

  Future<void> updateProfile(ProfileDto dto) async {
    emit(const ProfileLoading());

    final result = await _profileRepository.getLocalProfile(dto);

    result.when(
      ok: (response) => emit(ProfileUpdateSuccess(response.message)),
      error: (e) => emit(ProfileUpdateError('Failed to update profile: $e')),
    );
  }
}
