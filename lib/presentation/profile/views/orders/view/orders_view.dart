import 'dart:async';

import 'package:base_app/config/inject/app_injector.dart';
import 'package:base_app/domain/dto/pagination_dto.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:base_app/presentation/profile/views/orders/widgets/pagination_controls.dart';
import 'package:base_app/presentation/profile/views/orders/view_model/orders_cubit.dart';
import 'package:base_app/presentation/profile/views/orders/view_model/orders_state.dart';
import 'package:base_app/presentation/profile/views/orders/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  final OrdersCubit _cubit = AppInjector.inject.get<OrdersCubit>();

  @override
  void initState() {
    super.initState();
    unawaited(_cubit.fetchOrders(PaginationDto(page: 0)));
  }

  @override
  void dispose() {
    unawaited(_cubit.close());
    super.dispose();
  }

  void _goToPage(int page) {
    unawaited(
      _cubit.fetchOrders(PaginationDto(page: page)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.ordersTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<OrdersCubit, OrdersState>(
          bloc: _cubit,
          builder: (context, state) {
            if (state is OrdersLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is OrdersError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
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
                      onPressed: () =>
                          _cubit.fetchOrders(PaginationDto(page: 0)),
                      child: Text(l10n.retryButton),
                    ),
                  ],
                ),
              );
            }

            if (state is OrdersLoaded) {
              final orders = state.orders.data;

              if (orders.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 72,
                        color: colorScheme.onSurface.withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.ordersEmptyMessage,
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () =>
                          _cubit.fetchOrders(PaginationDto(page: 0)),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: orders.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          return OrderCard(
                            order: order,
                            onDetailsClosed: () =>
                                _cubit.fetchOrders(PaginationDto(page: 0)),
                          );
                        },
                      ),
                    ),
                  ),
                  PaginationControls(
                    cubit: _cubit,
                    onPageChanged: _goToPage,
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
