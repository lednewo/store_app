class OrderItemEntity {
  OrderItemEntity({
    required this.productId,
    required this.productName,
    required this.quantidade,
    required this.precoUnitario,
    required this.subtotal,
    required this.cor,
    required this.tamanho,
  });
  final String productId;
  final String productName;
  final int quantidade;
  final double precoUnitario;
  final double subtotal;
  final String cor;
  final int tamanho;
}
