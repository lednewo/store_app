class ProductDto {
  ProductDto({
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
  final String name;
  final String model;
  final String brand;
  final String description;
  final String gender;
  final String audience;
  final List<int> sizes;
  final List<String> colors;
  final double price;
  final String status;
  final List<String>? urlImages;

  Map<String, dynamic> toMap() => {
    'name': name,
    'model': model,
    'brand': brand,
    'description': description,
    'gender': gender,
    'audience': audience,
    'sizes': sizes,
    'colors': colors,
    'price': price,
    'status': status,
    if (urlImages != null) 'urlImages': urlImages,
  };
}
