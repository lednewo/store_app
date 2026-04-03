import 'dart:async';

import 'package:base_app/common/widgets/app_snackbar.dart';
import 'package:base_app/config/inject/app_injector.dart';
import 'package:base_app/domain/dto/update_order_status.dart';
import 'package:base_app/domain/enum/order_status_enum.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:base_app/presentation/profile/views/orders/content/order_details_content.dart';
import 'package:base_app/presentation/profile/views/orders/view_model/orders_cubit.dart';
import 'package:base_app/presentation/profile/views/orders/view_model/orders_state.dart';
import 'package:base_app/presentation/profile/views/orders/widgets/update_status_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderDetailsView extends StatefulWidget {
  const OrderDetailsView({
    required this.orderId,
    super.key,
  });
  final String orderId;

  @override
  State<OrderDetailsView> createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<OrderDetailsView> {
  final OrdersCubit _ordersCubit = AppInjector.inject.get<OrdersCubit>();
  bool _shouldRefreshOrders = false;

  @override
  void initState() {
    super.initState();
    unawaited(_ordersCubit.getOrderDetails(widget.orderId));
  }

  @override
  void dispose() {
    unawaited(_ordersCubit.close());
    super.dispose();
  }

  Future<void> showBottomSheetUpdateStatus(
    OrderStatusEnum currentStatus,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => UpdateStatusSheet(
        initialStatus: currentStatus,
        onConfirm: (status) {
          unawaited(
            _ordersCubit.updateStatusOrder(
              UpdateOrderStatus(
                orderId: widget.orderId,
                status: status.value,
              ),
            ),
          );
        },
      ),
    );
  }

  void _closeDetails() {
    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(_shouldRefreshOrders);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider.value(
      value: _ordersCubit,
      child: WillPopScope(
        onWillPop: () async {
          _closeDetails();
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: BackButton(onPressed: _closeDetails),
            title: Text(l10n.orderDetailsTitle),
            centerTitle: true,
          ),
          body: SafeArea(
            top: false,
            child: BlocConsumer<OrdersCubit, OrdersState>(
              listener: (context, state) {
                if (state is OrdersError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
                if (state is OrderStatusUpdateError) {
                  AppSnackbar.showError(context, message: state.message);
                }
                if (state is OrderStatusUpdated) {
                  _shouldRefreshOrders = true;
                  AppSnackbar.showSuccess(context, message: state.message);
                  unawaited(_ordersCubit.getOrderDetails(widget.orderId));
                }
              },
              builder: (context, state) {
                if (state is OrdersLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is OrdersError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 64,
                            color: colorScheme.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.error,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: () {
                              unawaited(
                                _ordersCubit.getOrderDetails(widget.orderId),
                              );
                            },
                            child: Text(l10n.retryButton),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is OrderDetailsLoaded) {
                  return OrderDetailsContent(
                    orderDetails: state.orderDetails,
                    updateStatus: () {
                      unawaited(
                        showBottomSheetUpdateStatus(
                          OrderStatusEnum.fromString(
                            state.orderDetails.status,
                          ),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
