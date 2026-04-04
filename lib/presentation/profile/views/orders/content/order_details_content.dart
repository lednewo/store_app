import 'package:base_app/common/utils/login_detect.dart';
import 'package:base_app/domain/entities/order_detail_entity.dart';
import 'package:base_app/domain/enum/order_status_enum.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:base_app/presentation/profile/views/orders/widgets/buyer_info_card.dart';
import 'package:base_app/presentation/profile/views/orders/widgets/order_detail_item_card.dart';
import 'package:base_app/presentation/profile/views/orders/widgets/order_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetailsContent extends StatelessWidget {
  const OrderDetailsContent({
    required this.orderDetails,
    required this.updateStatus,
    required this.onDeleteOrder,
    super.key,
  });

  final OrderDetailEntity orderDetails;
  final VoidCallback updateStatus;
  final VoidCallback onDeleteOrder;
  @override
  Widget build(BuildContext context) {
    final localeName = Localizations.localeOf(context).toString();
    final dateFormatter = DateFormat.yMMMd(localeName).add_Hm();
    final currencyFormatter = NumberFormat.currency(
      locale: localeName,
      symbol: r'R$',
    );
    final status = OrderStatusEnum.fromString(orderDetails.status);
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        OrderSummaryCard(
          orderDetails: orderDetails,
          status: status,
          formattedDate: dateFormatter.format(orderDetails.orderDate),
          formattedTotal: currencyFormatter.format(orderDetails.total),
          onUpdateStatus: updateStatus,
          onDeleteOrder: onDeleteOrder,
        ),
        const SizedBox(height: 16),

        if (!LoginDetect.isCliente) ...[
          Text(
            l10n.orderDetailsBuyerTitle,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          BuyerInfoCard(orderDetails: orderDetails),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.orderDetailsProductsTitle,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              l10n.orderDetailsItemsCount(orderDetails.items.length),
              style: textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (orderDetails.items.isEmpty)
          _EmptyItemsCard(message: l10n.orderDetailsEmptyItemsMessage)
        else
          ...orderDetails.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: OrderDetailItemCard(
                item: item,
                unitPriceLabel: l10n.orderDetailsUnitPriceLabel,
                formattedUnitPrice: currencyFormatter.format(
                  item.precoUnitario,
                ),
                formattedSubtotal: currencyFormatter.format(item.subtotal),
              ),
            ),
          ),
      ],
    );
  }
}

class _EmptyItemsCard extends StatelessWidget {
  const _EmptyItemsCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 40,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
