import 'package:flutter/foundation.dart';

@immutable
sealed class SplashState {
  const SplashState();
}

class SplashInitial extends SplashState {
  const SplashInitial();
}

class SplashLoading extends SplashState {
  const SplashLoading();
}

class SplashNavigateToHome extends SplashState {
  const SplashNavigateToHome();
}

class SplashNavigateToLogin extends SplashState {
  const SplashNavigateToLogin();
}

class SplashError extends SplashState {
  const SplashError(this.message);

  final String message;
}
