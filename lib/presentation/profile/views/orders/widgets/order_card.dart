import 'dart:ui';

import 'package:base_app/common/widgets/app_button.dart';
import 'package:base_app/config/routes/app_routes.dart';
import 'package:base_app/domain/entities/order_entity.dart';
import 'package:base_app/domain/entities/order_item_entity.dart';
import 'package:base_app/domain/enum/order_status_enum.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    required this.order,
    this.onDetailsClosed,
    super.key,
  });

  final OrderEntity order;
  final Future<void> Function()? onDetailsClosed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final formattedDate = DateFormat(
      'dd/MM/yyyy HH:mm',
    ).format(order.orderDate);

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: colorScheme.surface,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.receipt_long_rounded,
                  size: 20,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${l10n.ordersOrderLabel} #${_shortOrderId(order.orderId)}',
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 11,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formattedDate,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          trailing: _StatusChip(status: order.status),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(
                height: 1,
                color: colorScheme.outlineVariant.withValues(alpha: .5),
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: order.items.length,
              itemBuilder: (context, index) {
                final item = order.items[index];
                return _OrderItemRow(item: item);
              },
            ),

            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.primaryContainer,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 16,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${order.items.length} ${order.items.length == 1 ? 'item' : 'itens'}',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        l10n.cartTotalLabel,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'R\$ ${order.total.toStringAsFixed(2).replaceAll('.', ',')}',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            AppButton(
              label: l10n.orderDetailsOpenButton,
              variant: AppButtonVariant.secondary,
              onTap: () async {
                final shouldRefresh = await context.push<bool>(
                  AppRoutes.orderDetails,
                  extra: order.orderId,
                );

                if (!context.mounted || shouldRefresh != true) {
                  return;
                }

                await onDetailsClosed?.call();
              },
              isFullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  const _OrderItemRow({required this.item});

  final OrderItemEntity item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${item.quantidade}x',
                style: textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _AttributePill(
                      icon: Icons.palette_outlined,
                      label: item.cor,
                    ),
                    _AttributePill(
                      icon: Icons.straighten_outlined,
                      label: item.tamanho.toString(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),
          Text(
            'R\$ ${item.subtotal.toStringAsFixed(2).replaceAll('.', ',')}',
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _AttributePill extends StatelessWidget {
  const _AttributePill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

String _shortOrderId(String orderId) {
  final endIndex = orderId.length < 8 ? orderId.length : 8;
  return orderId.substring(0, endIndex).toUpperCase();
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final OrderStatusEnum status;

  Color _color(BuildContext context) {
    return switch (status) {
      OrderStatusEnum.pendente => const Color(0xFFE65100),
      OrderStatusEnum.pago => const Color(0xFF2E7D32),
      OrderStatusEnum.enviado => const Color(0xFF1565C0),
      OrderStatusEnum.entregue => const Color(0xFF2E7D32),
      OrderStatusEnum.cancelado => Theme.of(context).colorScheme.error,
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = _color(context);
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(100)),
      ),
      child: Text(
        switch (status) {
          OrderStatusEnum.pendente => l10n.orderDetailsStatusPending,
          OrderStatusEnum.pago => l10n.orderDetailsStatusPaid,
          OrderStatusEnum.enviado => l10n.orderDetailsStatusShipped,
          OrderStatusEnum.entregue => l10n.orderDetailsStatusDelivered,
          OrderStatusEnum.cancelado => l10n.orderDetailsStatusCancelled,
        },
        style: textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
