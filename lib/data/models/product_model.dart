import 'package:base_app/domain/entities/product_entity.dart';
import 'package:base_app/domain/enum/audience_enum.dart';
import 'package:base_app/domain/enum/gender_enum.dart';
import 'package:base_app/domain/enum/status_enum.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.name,
    required super.model,
    required super.brand,
    required super.description,
    required super.gender,
    required super.audience,
    required super.sizes,
    required super.colors,
    required super.price,
    required super.status,
    required super.urlImages,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      model: json['model'] as String,
      brand: json['brand'] as String,
      description: json['description'] as String,
      gender: GenderEnum.fromString(json['gender'] as String),
      audience: AudienceEnum.fromString(json['audience'] as String),
      sizes: (json['sizes'] as List<dynamic>).map((e) => e as int).toList(),
      colors: (json['colors'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      price: json['price'] as double,
      status: StatusEnum.fromString(json['status'] as String),
      urlImages: (json['urlImages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }
}
