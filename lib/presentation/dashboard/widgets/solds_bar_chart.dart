import 'package:base_app/domain/entities/solds_quantity_entity.dart';
import 'package:base_app/presentation/dashboard/widgets/solds_bar_chart_painter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SoldsBarChart extends StatefulWidget {
  const SoldsBarChart({
    super.key,
    required this.data,
  });

  final List<SoldsQuantityEntity> data;

  @override
  State<SoldsBarChart> createState() => _SoldsBarChartState();
}

class _SoldsBarChartState extends State<SoldsBarChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _monthAbbr(int month) {
    const months = [
      'Jan',
      'Fev',
      'Mar',
      'Abr',
      'Mai',
      'Jun',
      'Jul',
      'Ago',
      'Set',
      'Out',
      'Nov',
      'Dez',
    ];
    if (month < 1 || month > 12) return '';
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currencyFormat = NumberFormat.compactCurrency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 0,
    );

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) => RepaintBoundary(
        child: CustomPaint(
          size: Size.infinite,
          painter: SoldsBarChartPainter(
            data: widget.data,
            animationValue: _animation.value,
            barColor: colorScheme.primary,
            labelColor: colorScheme.onSurface,
            monthLabels: widget.data
                .map((e) => '${_monthAbbr(e.month)}/${e.year}')
                .toList(),
            amountLabels: widget.data
                .map((e) => currencyFormat.format(e.totalAmount))
                .toList(),
          ),
        ),
      ),
    );
  }
}
