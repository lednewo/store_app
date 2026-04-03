class UpdateOrderStatus {
  UpdateOrderStatus({
    required this.orderId,
    required this.status,
  });
  final String orderId;
  final String status;

  Map<String, dynamic> toMap() => {
    'orderId': orderId,
    'status': status,
  };
}
