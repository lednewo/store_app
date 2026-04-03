import 'package:base_app/data/models/profile_model.dart';
import 'package:base_app/domain/entities/login_entity.dart';

class LoginModel extends LoginEntity {
  LoginModel({
    required super.message,
    required super.token,
    required super.expirationDate,
    required super.profile,
    required super.role,
  });

  factory LoginModel.fromMap(Map<String, dynamic> map) {
    return LoginModel(
      message: map['message'] as String? ?? '',
      token: map['token'] as String? ?? '',
      expirationDate: map['expirationDate'] as String? ?? '',
      profile: ProfileModel.fromMap(
        map['profile'] as Map<String, dynamic>? ?? {},
      ),
      role: map['role'] as String? ?? '',
    );
  }
}
