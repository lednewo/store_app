enum OrderStatusEnum {
  pendente('PENDENTE'),
  pago('PAGO'),
  enviado('ENVIADO'),
  entregue('ENTREGUE'),
  cancelado('CANCELADO');

  const OrderStatusEnum(this.value);
  final String value;

  static OrderStatusEnum fromString(String value) {
    return OrderStatusEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => OrderStatusEnum.pendente,
    );
  }

  String get label {
    switch (this) {
      case OrderStatusEnum.pendente:
        return 'Pendente';
      case OrderStatusEnum.pago:
        return 'Pago';
      case OrderStatusEnum.enviado:
        return 'Enviado';
      case OrderStatusEnum.entregue:
        return 'Entregue';
      case OrderStatusEnum.cancelado:
        return 'Cancelado';
    }
  }
}
