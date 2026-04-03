class RegisterDto {
  RegisterDto({
    required this.name,
    required this.password,
    required this.email,
    required this.phone,
    required this.address,
  });
  final String name;
  final String password;
  final String email;
  final String phone;
  final String address;

  Map<String, dynamic> toMap() => {
    'name': name,
    'password': password,
    'email': email,
    'phone': phone,
    'address': address,
  };
}
