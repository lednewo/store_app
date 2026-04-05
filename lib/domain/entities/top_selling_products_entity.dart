class TopSellingProductsEntity {
  TopSellingProductsEntity({
    required this.productId,
    required this.name,
    required this.model,
    required this.brand,
    required this.price,
    required this.totalQuantidadeVendida,
    required this.totalRevenue,
  });
  final String productId;
  final String name;
  final String model;
  final String brand;
  final double price;
  final int totalQuantidadeVendida;
  final double totalRevenue;
}
