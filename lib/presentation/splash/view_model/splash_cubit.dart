import 'package:base_app/domain/interfaces/auth_repository.dart';
import 'package:base_app/presentation/splash/view_model/splash_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this._authRepository) : super(const SplashInitial());

  final AuthRepository _authRepository;

  Future<void> initialize() async {
    emit(const SplashLoading());

    final isAuthenticated = await _authRepository.isAuthenticated;

    if (isAuthenticated) {
      emit(const SplashNavigateToHome());
    } else {
      emit(const SplashNavigateToLogin());
    }
  }
}
