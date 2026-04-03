import 'package:base_app/domain/entities/order_detail_entity.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:flutter/material.dart';

class BuyerInfoCard extends StatelessWidget {
  const BuyerInfoCard({required this.orderDetails, super.key});

  final OrderDetailEntity orderDetails;

  @override
  Widget build(BuildContext context) {
    final buyer = orderDetails.comprador;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          _BuyerInfoTile(
            icon: Icons.person_outline,
            label: context.l10n.profileNameLabel,
            value: _displayValue(context, buyer.name),
          ),
          const Divider(height: 1, indent: 56),
          _BuyerInfoTile(
            icon: Icons.phone_outlined,
            label: context.l10n.profilePhoneLabel,
            value: _displayValue(context, buyer.phone),
          ),
          const Divider(height: 1, indent: 56),
          _BuyerInfoTile(
            icon: Icons.location_on_outlined,
            label: context.l10n.profileAddressLabel,
            value: _displayValue(context, buyer.address),
          ),
        ],
      ),
    );
  }
}

class _BuyerInfoTile extends StatelessWidget {
  const _BuyerInfoTile({
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

    return ListTile(
      leading: Icon(icon, color: colorScheme.primary),
      title: Text(
        label,
        style: textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      subtitle: Text(value, style: textTheme.bodyMedium),
      visualDensity: VisualDensity.comfortable,
    );
  }
}

String _displayValue(BuildContext context, String value) {
  if (value.trim().isEmpty) {
    return context.l10n.orderDetailsNotProvidedLabel;
  }

  return value;
}
