class OrderItemDto {
  OrderItemDto({
    required this.productId,
    required this.quantidade,
    required this.cor,
    required this.tamanho,
  });
  final String productId;
  final int quantidade;
  final String cor;
  final int tamanho;

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantidade': quantidade,
      'cor': cor,
      'tamanho': tamanho,
    };
  }
}
