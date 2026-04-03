import 'package:base_app/domain/dto/pagination_dto.dart';
import 'package:base_app/domain/dto/update_order_status.dart';
import 'package:base_app/domain/interfaces/order_repository.dart';
import 'package:base_app/presentation/profile/views/orders/view_model/orders_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit(this._orderRepository) : super(const OrdersInitial());

  final OrderRepository _orderRepository;

  bool hasMore = false;
  int totalPages = 0;
  int currentPage = 0;

  bool get canGoPrevius => currentPage > 0;
  bool get canGoNext => currentPage + 1 < totalPages;

  Future<void> fetchOrders(PaginationDto dto) async {
    emit(const OrdersLoading());

    final result = await _orderRepository.fetchOrders(dto);

    result.when(
      ok: (success) {
        hasMore =
            success.data.length == dto.size && currentPage < totalPages - 1;
        totalPages = success.totalPages;
        emit(OrdersLoaded(success));
      },
      error: (e) => emit(OrdersError(e.toString())),
    );
  }

  Future<void> updateStatusOrder(UpdateOrderStatus dto) async {
    emit(const OrdersLoading());

    final result = await _orderRepository.updateStatusOrder(dto);
    result.when(
      ok: (success) => emit(OrderStatusUpdated(success.message)),
      error: (e) => emit(OrderStatusUpdateError(e.toString())),
    );
  }

  Future<void> getOrderDetails(String id) async {
    emit(const OrdersLoading());

    final result = await _orderRepository.getOrderDetails(id);
    result.when(
      ok: (details) => emit(OrderDetailsLoaded(details)),
      error: (e) => emit(OrdersError(e.toString())),
    );
  }
}
