import 'package:base_app/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required super.name,
    required super.email,
    required super.phone,
    required super.userType,
    required super.address,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      userType: map['userType'] as String? ?? '',
      address: map['address'] as String? ?? '',
    );
  }
  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      userType: entity.userType,
      address: entity.address,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'userType': userType,
      'address': address,
    };
  }
}
