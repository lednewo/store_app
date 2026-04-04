import 'package:base_app/domain/entities/solds_quantity_entity.dart';

class SoldsQuantityModel extends SoldsQuantityEntity {
  SoldsQuantityModel({
    required super.year,
    required super.month,
    required super.quantity,
    required super.totalAmount,
  });

  factory SoldsQuantityModel.fromJson(Map<String, dynamic> json) {
    return SoldsQuantityModel(
      year: json['year'] as int,
      month: json['month'] as int,
      quantity: json['quantity'] as int,
      totalAmount: (json['totalAmount'] as num).toDouble(),
    );
  }
}
