import 'package:base_app/presentation/profile/views/orders/view_model/orders_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PaginationControls extends StatelessWidget {
  const PaginationControls({
    required this.cubit,
    required this.onPageChanged,
    required this.colorScheme,
    required this.textTheme,
    super.key,
  });

  final OrdersCubit cubit;
  final void Function(int page) onPageChanged;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton.outlined(
            onPressed: cubit.canGoPrevius
                ? () => onPageChanged(cubit.currentPage - 1)
                : null,
            icon: const Icon(Icons.chevron_left),
            tooltip: 'Página anterior',
          ),
          Text(
            '${cubit.currentPage + 1} / ${cubit.totalPages}',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton.outlined(
            onPressed: cubit.canGoNext
                ? () => onPageChanged(cubit.currentPage + 1)
                : null,
            icon: const Icon(Icons.chevron_right),
            tooltip: 'Próxima página',
          ),
        ],
      ),
    );
  }
}
