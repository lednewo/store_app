import 'package:base_app/domain/enum/audience_enum.dart';
import 'package:base_app/domain/enum/gender_enum.dart';
import 'package:base_app/domain/enum/status_enum.dart';

class ProductEntity {
  ProductEntity({
    required this.id,
    required this.name,
    required this.model,
    required this.brand,
    required this.description,
    required this.gender,
    required this.audience,
    required this.sizes,
    required this.colors,
    required this.price,
    required this.status,
    required this.urlImages,
  });
  final String id;
  final String name;
  final String model;
  final String brand;
  final String description;
  final GenderEnum gender;
  final AudienceEnum audience;
  final List<int> sizes;
  final List<String> colors;
  final double price;
  final StatusEnum status;
  final List<String> urlImages;
}
