import 'package:flutter/foundation.dart';

@immutable
sealed class RegisterState {
  const RegisterState();
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

class RegisterSuccess extends RegisterState {
  const RegisterSuccess(this.message);

  final String message;
}

class RegisterError extends RegisterState {
  const RegisterError(this.message);

  final String message;
}
