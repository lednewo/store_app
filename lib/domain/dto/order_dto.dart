import 'package:base_app/domain/dto/order_item_dto.dart';

class OrderDto {
  OrderDto({
    required this.items,
  });
  List<OrderItemDto> items;

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
