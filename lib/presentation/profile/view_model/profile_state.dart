import 'package:base_app/domain/entities/profile_entity.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded({required this.profile});

  final ProfileEntity profile;
}

class ProfileError extends ProfileState {
  const ProfileError(this.message);

  final String message;
}

class ProfileLoggedOut extends ProfileState {
  const ProfileLoggedOut();
}

class ProfileUpdateSuccess extends ProfileState {
  const ProfileUpdateSuccess(this.message);
  final String message;
}

class ProfileUpdateError extends ProfileState {
  const ProfileUpdateError(this.message);
  final String message;
}
