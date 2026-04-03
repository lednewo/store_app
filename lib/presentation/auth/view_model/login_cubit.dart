import 'package:base_app/domain/dto/login_dto.dart';
import 'package:base_app/domain/interfaces/auth_repository.dart';
import 'package:base_app/presentation/auth/view_model/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepository) : super(const LoginInitial());

  final AuthRepository _authRepository;

  Future<void> login(LoginDto dto) async {
    emit(const LoginLoading());

    final result = await _authRepository.login(dto);

    result.when(
      ok: (login) => emit(LoginLoaded(login)),
      error: (error) => emit(const LoginError('Usuário ou senha inválidos.')),
    );
  }

  LoginErrorType _mapErrorType(Exception error) {
    final message = error.toString().toLowerCase();

    if (message.contains('401') || message.contains('unauthorized')) {
      return LoginErrorType.invalidCredentials;
    }

    if (message.contains('socketexception') ||
        message.contains('connection error') ||
        message.contains('network')) {
      return LoginErrorType.noInternet;
    }

    if (message.contains('timeout')) {
      return LoginErrorType.timeout;
    }

    return LoginErrorType.generic;
  }
}
