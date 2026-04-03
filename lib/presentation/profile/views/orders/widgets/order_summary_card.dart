import 'package:base_app/common/utils/login_detect.dart';
import 'package:base_app/common/widgets/app_button.dart';
import 'package:base_app/domain/entities/order_detail_entity.dart';
import 'package:base_app/domain/enum/order_status_enum.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:flutter/material.dart';

class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({
    required this.orderDetails,
    required this.status,
    required this.formattedDate,
    required this.formattedTotal,
    required this.onUpdateStatus,
    super.key,
  });

  final OrderDetailEntity orderDetails;
  final OrderStatusEnum status;
  final VoidCallback onUpdateStatus;
  final String formattedDate;
  final String formattedTotal;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.receipt_long_rounded,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${l10n.ordersOrderLabel} #${_shortOrderId(orderDetails.orderId)}',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.orderDetailsItemsCount(orderDetails.items.length),
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                _OrderStatusBadge(status: status),
              ],
            ),
            const SizedBox(height: 20),
            _MetadataTile(
              icon: Icons.tag_outlined,
              label: l10n.orderDetailsOrderIdLabel,
              value: orderDetails.orderId,
            ),
            const SizedBox(height: 12),
            _MetadataTile(
              icon: Icons.calendar_today_outlined,
              label: l10n.orderDetailsDateLabel,
              value: formattedDate,
            ),
            const SizedBox(height: 12),
            _MetadataTile(
              icon: Icons.info_outline,
              label: l10n.orderDetailsStatusLabel,
              value: _statusLabel(context, status),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.cartTotalLabel,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    formattedTotal,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            if (!LoginDetect.isCliente)
              AppButton(
                label: l10n.orderDetailsUpdateStatusButton,
                onTap: onUpdateStatus,
                isFullWidth: true,
              ),
          ],
        ),
      ),
    );
  }
}

class _MetadataTile extends StatelessWidget {
  const _MetadataTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

String _shortOrderId(String orderId) {
  final endIndex = orderId.length < 8 ? orderId.length : 8;
  return orderId.substring(0, endIndex).toUpperCase();
}

class _OrderStatusBadge extends StatelessWidget {
  const _OrderStatusBadge({required this.status});

  final OrderStatusEnum status;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(context, status);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        _statusLabel(context, status),
        style: textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

Color _statusColor(BuildContext context, OrderStatusEnum status) {
  return switch (status) {
    OrderStatusEnum.pendente => const Color(0xFFE65100),
    OrderStatusEnum.pago => const Color(0xFF2E7D32),
    OrderStatusEnum.enviado => const Color(0xFF1565C0),
    OrderStatusEnum.entregue => const Color(0xFF2E7D32),
    OrderStatusEnum.cancelado => Theme.of(context).colorScheme.error,
  };
}

String _statusLabel(BuildContext context, OrderStatusEnum status) {
  final l10n = context.l10n;

  return switch (status) {
    OrderStatusEnum.pendente => l10n.orderDetailsStatusPending,
    OrderStatusEnum.pago => l10n.orderDetailsStatusPaid,
    OrderStatusEnum.enviado => l10n.orderDetailsStatusShipped,
    OrderStatusEnum.entregue => l10n.orderDetailsStatusDelivered,
    OrderStatusEnum.cancelado => l10n.orderDetailsStatusCancelled,
  };
}
