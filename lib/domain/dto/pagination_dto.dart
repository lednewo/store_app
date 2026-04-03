import 'package:base_app/domain/enum/status_enum.dart';

class PaginationDto {
  PaginationDto({
    required this.page,
    this.size = 10,
    this.name,
    this.model,
    this.brand,
    this.status,
    this.minPrice,
    this.maxPrice,
  });
  final int page;
  final int size;
  final String? name;
  final String? model;
  final String? brand;
  final StatusEnum? status;
  final double? minPrice;
  final double? maxPrice;

  Map<String, dynamic> toMap() => {
    'page': page,
    'size': size,
    if (name != null) 'name': name,
    if (model != null) 'model': model,
    if (brand != null) 'brand': brand,
    if (status != null) 'status': status!.name,
    if (minPrice != null) 'minPrice': minPrice,
    if (maxPrice != null) 'maxPrice': maxPrice,
  };
}
