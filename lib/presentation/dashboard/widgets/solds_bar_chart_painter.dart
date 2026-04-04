import 'dart:math';

import 'package:base_app/domain/entities/solds_quantity_entity.dart';
import 'package:flutter/material.dart';

class SoldsBarChartPainter extends CustomPainter {
  const SoldsBarChartPainter({
    required this.data,
    required this.animationValue,
    required this.barColor,
    required this.labelColor,
    required this.monthLabels,
    required this.amountLabels,
  });

  final List<SoldsQuantityEntity> data;
  final double animationValue;
  final Color barColor;
  final Color labelColor;
  final List<String> monthLabels;
  final List<String> amountLabels;

  static const double _paddingTop = 28;
  static const double _paddingBottom = 52;
  static const double _paddingHorizontal = 12;
  static const double _barRadiusValue = 6;
  static const double _labelFontSize = 12;
  static const double _valueFontSize = 13;
  static const int _gridLines = 4;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxQ = data.map((e) => e.quantity).reduce(max).toDouble();
    if (maxQ == 0) return;

    final chartWidth = size.width - _paddingHorizontal * 2;
    final chartHeight = size.height - _paddingTop - _paddingBottom;
    final slotWidth = chartWidth / data.length;
    final barWidth = slotWidth * 0.55;

    final gridPaint = Paint()
      ..color = labelColor.withValues(alpha: 0.12)
      ..strokeWidth = 1;

    for (var i = 0; i <= _gridLines; i++) {
      final y = _paddingTop + chartHeight * (1 - i / _gridLines);
      canvas.drawLine(
        Offset(_paddingHorizontal, y),
        Offset(size.width - _paddingHorizontal, y),
        gridPaint,
      );

      final gridValue = (maxQ * i / _gridLines).round();
      _drawText(
        canvas: canvas,
        text: gridValue.toString(),
        x: _paddingHorizontal - 4,
        y: y - 6,
        fontSize: 10,
        color: labelColor.withValues(alpha: 0.5),
        alignRight: true,
      );
    }

    final barPaint = Paint()
      ..color = barColor
      ..style = PaintingStyle.fill;

    for (var i = 0; i < data.length; i++) {
      final entry = data[i];
      final barHeight = (entry.quantity / maxQ) * chartHeight * animationValue;
      final slotX = _paddingHorizontal + slotWidth * i;
      final x = slotX + (slotWidth - barWidth) / 2;
      final top = _paddingTop + chartHeight - barHeight;
      final bottom = _paddingTop + chartHeight;

      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          barColor,
          barColor.withValues(alpha: 0.7),
        ],
      );
      final barRect = Rect.fromLTRB(x, top, x + barWidth, bottom);
      barPaint.shader = gradient.createShader(barRect);

      final rrect = RRect.fromRectAndRadius(
        barRect,
        const Radius.circular(_barRadiusValue),
      );
      canvas.drawRRect(rrect, barPaint);

      _drawText(
        canvas: canvas,
        text: monthLabels[i],
        x: slotX + slotWidth / 2,
        y: _paddingTop + chartHeight + 8,
        fontSize: _labelFontSize,
        color: labelColor.withValues(alpha: 0.75),
      );

      _drawText(
        canvas: canvas,
        text: amountLabels[i],
        x: slotX + slotWidth / 2,
        y: _paddingTop + chartHeight + 8 + _labelFontSize + 4,
        fontSize: 10,
        color: labelColor.withValues(alpha: 0.55),
      );

      if (animationValue > 0.65) {
        final opacity = ((animationValue - 0.65) / 0.35).clamp(0.0, 1.0);
        _drawText(
          canvas: canvas,
          text: entry.quantity.toString(),
          x: slotX + slotWidth / 2,
          y: top - _valueFontSize - 4,
          fontSize: _valueFontSize,
          color: barColor.withValues(alpha: opacity),
          bold: true,
        );
      }
    }
  }

  void _drawText({
    required Canvas canvas,
    required String text,
    required double x,
    required double y,
    required double fontSize,
    required Color color,
    bool bold = false,
    bool alignRight = false,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final dx = alignRight ? x - tp.width : x - tp.width / 2;
    tp.paint(canvas, Offset(dx, y));
  }

  @override
  bool shouldRepaint(SoldsBarChartPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue ||
      oldDelegate.data != data ||
      oldDelegate.barColor != barColor ||
      oldDelegate.labelColor != labelColor ||
      oldDelegate.amountLabels != amountLabels;
}
