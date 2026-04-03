import 'package:base_app/domain/interfaces/order_repository.dart';
import 'package:base_app/presentation/profile/views/orders/view_model/orders_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit(this._orderRepository) : super(const OrdersInitial());

  final OrderRepository _orderRepository;

  Future<void> fetchOrders() async {
    emit(const OrdersLoading());

    final result = await _orderRepository.fetchOrders();

    result.when(
      ok: (orders) => emit(OrdersLoaded(orders)),
      error: (e) => emit(OrdersError(e.toString())),
    );
  }
}
