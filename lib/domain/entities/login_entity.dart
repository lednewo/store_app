import 'package:base_app/domain/entities/profile_entity.dart';

class LoginEntity {
  const LoginEntity({
    required this.message,
    required this.token,
    required this.expirationDate,
    required this.profile,
    required this.role,
  });
  final String message;
  final String token;
  final String expirationDate;
  final ProfileEntity profile;
  final String role;
}
