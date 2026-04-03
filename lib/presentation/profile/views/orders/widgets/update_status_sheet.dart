// update_status_sheet.dart

import 'package:base_app/domain/enum/order_status_enum.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:flutter/material.dart';

class UpdateStatusSheet extends StatefulWidget {
  const UpdateStatusSheet({
    required this.initialStatus,
    required this.onConfirm,
    super.key,
  });

  final OrderStatusEnum initialStatus;
  final ValueChanged<OrderStatusEnum> onConfirm;

  @override
  State<UpdateStatusSheet> createState() => _UpdateStatusSheetState();
}

class _UpdateStatusSheetState extends State<UpdateStatusSheet> {
  late OrderStatusEnum _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialStatus;
  }

  Color _statusColor(OrderStatusEnum status) => switch (status) {
    OrderStatusEnum.pendente => const Color(0xFFE65100),
    OrderStatusEnum.pago => const Color(0xFF2E7D32),
    OrderStatusEnum.enviado => const Color(0xFF1565C0),
    OrderStatusEnum.entregue => const Color(0xFF2E7D32),
    OrderStatusEnum.cancelado => Theme.of(context).colorScheme.error,
  };

  IconData _statusIcon(OrderStatusEnum status) => switch (status) {
    OrderStatusEnum.pendente => Icons.hourglass_empty_rounded,
    OrderStatusEnum.pago => Icons.check_circle_outline_rounded,
    OrderStatusEnum.enviado => Icons.local_shipping_outlined,
    OrderStatusEnum.entregue => Icons.inventory_2_outlined,
    OrderStatusEnum.cancelado => Icons.cancel_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.edit_note_rounded,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.orderDetailsUpdateStatusSheetTitle,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      l10n.orderDetailsUpdateStatusSheetSubtitle,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          Divider(
            height: 1,
            color: colorScheme.outlineVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 8),

          ...OrderStatusEnum.values.map((status) {
            final isSelected = _selected == status;
            final color = _statusColor(status);

            return InkWell(
              onTap: () => setState(() => _selected = status),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? color.withValues(alpha: 0.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? color.withValues(alpha: 0.35)
                        : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? color.withValues(alpha: 0.15)
                            : colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _statusIcon(status),
                        size: 18,
                        color: isSelected
                            ? color
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        switch (status) {
                          OrderStatusEnum.pendente =>
                            l10n.orderDetailsStatusPending,
                          OrderStatusEnum.pago => l10n.orderDetailsStatusPaid,
                          OrderStatusEnum.enviado =>
                            l10n.orderDetailsStatusShipped,
                          OrderStatusEnum.entregue =>
                            l10n.orderDetailsStatusDelivered,
                          OrderStatusEnum.cancelado =>
                            l10n.orderDetailsStatusCancelled,
                        },
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSelected ? color : colorScheme.onSurface,
                        ),
                      ),
                    ),

                    AnimatedOpacity(
                      opacity: isSelected ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 180),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          size: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FilledButton(
              onPressed: () {
                widget.onConfirm(_selected);
                Navigator.of(context).pop();
              },
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(l10n.orderDetailsUpdateStatusConfirmButton),
            ),
          ),
        ],
      ),
    );
  }
}
