import 'package:base_app/domain/entities/login_entity.dart';
import 'package:flutter/foundation.dart';

enum LoginErrorType {
  invalidCredentials,
  noInternet,
  timeout,
  generic,
}

@immutable
sealed class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginLoaded extends LoginState {
  const LoginLoaded(this.login);

  final LoginEntity login;
}

class LoginError extends LoginState {
  const LoginError(
    this.message,
    // this.type
  );
  final String message;

  // final LoginErrorType type;
}
