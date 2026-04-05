import 'package:base_app/domain/entities/top_selling_products_entity.dart';

class TopSellingProductsModel extends TopSellingProductsEntity {
  TopSellingProductsModel({
    required super.productId,
    required super.name,
    required super.model,
    required super.brand,
    required super.price,
    required super.totalQuantidadeVendida,
    required super.totalRevenue,
  });

  factory TopSellingProductsModel.fromJson(Map<String, dynamic> json) =>
      TopSellingProductsModel(
        productId: json['productId'] as String? ?? '',
        name: json['name'] as String? ?? '',
        model: json['model'] as String? ?? '',
        brand: json['brand'] as String? ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        totalQuantidadeVendida: json['totalQuantidadeVendida'] as int? ?? 0,
        totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      );
}
