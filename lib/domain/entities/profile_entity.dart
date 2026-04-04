class ProfileEntity {
  const ProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    required this.address,
  });
  final String id;
  final String name;
  final String email;
  final String phone;
  final String userType;
  final String address;
}
