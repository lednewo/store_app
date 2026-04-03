import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension LoginStringExtension on String {
  LoginType get loginType => LoginType.values.firstWhere(
    (type) => type.value == toLowerCase(),
    orElse: () => LoginType.cliente,
  );
}

enum LoginType {
  vendedor('vendedor'),
  cliente('cliente');

  const LoginType(this.value);
  final String value;
}

class LoginDetect {
  static ValueNotifier<LoginType> loginTypeNotifier = ValueNotifier(
    LoginType.cliente,
  );

  static void setLoginType(LoginType type) async {
    loginTypeNotifier.value = type;
    final refs = await SharedPreferences.getInstance();
    await refs.setString('loginType', type.value);
  }

  static Future<LoginType> getLoginType() async {
    final refs = await SharedPreferences.getInstance();
    final typeString = refs.getString('loginType') ?? LoginType.cliente.value;
    final type = LoginType.values.firstWhere(
      (t) => t.value == typeString,
      orElse: () => LoginType.cliente,
    );
    loginTypeNotifier.value = type;
    return loginTypeNotifier.value;
  }

  static bool get isVendedor => loginTypeNotifier.value == LoginType.vendedor;
  static bool get isCliente => loginTypeNotifier.value == LoginType.cliente;
}
