import 'package:base_app/domain/dto/register_dto.dart';
import 'package:base_app/domain/interfaces/auth_repository.dart';
import 'package:base_app/presentation/auth/view_model/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._authRepository) : super(const RegisterInitial());

  final AuthRepository _authRepository;

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
  }) async {
    emit(const RegisterLoading());

    final result = await _authRepository.register(
      RegisterDto(
        name: name.trim(),
        email: email.trim(),
        password: password,
        phone: phone.trim(),
        address: address.trim(),
      ),
    );

    result.when(
      ok: (data) => emit(RegisterSuccess(data.message)),
      error: (error) => emit(RegisterError(error.toString())),
    );
  }
}
