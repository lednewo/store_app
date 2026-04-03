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
}
