class ProfileDto {
  ProfileDto({
    required this.id,
    this.name,
    this.phone,
    this.address,
  });
  final String id;
  final String? name;
  final String? phone;
  final String? address;

  Map<String, dynamic> toMap() => {
    'id': id,
    if (name != null) 'name': name,
    if (phone != null) 'phone': phone,
    if (address != null) 'address': address,
  };
}
