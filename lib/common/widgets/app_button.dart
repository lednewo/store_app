import 'package:flutter/material.dart';

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onTap,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
  });

  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;

  @override
  State<AppButton> createState() => _AppButtonState();
}

enum AppButtonVariant { primary, secondary, ghost, destructive }

enum AppButtonSize { small, medium, large }

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) {
    if (widget.onTap == null || widget.isLoading) return;
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _onTapUp(_) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDisabled = widget.onTap == null;

    // — Tamanhos —
    final (padding, textStyle, iconSize, borderRadius) = switch (widget.size) {
      AppButtonSize.small => (
        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        textTheme.labelSmall,
        14.0,
        8.0,
      ),
      AppButtonSize.medium => (
        const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textTheme.labelMedium,
        16.0,
        12.0,
      ),
      AppButtonSize.large => (
        const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        textTheme.labelLarge,
        18.0,
        14.0,
      ),
    };

    // — Cores por variante —
    final (bgColor, fgColor, borderColor) = switch (widget.variant) {
      AppButtonVariant.primary => (
        isDisabled
            ? colorScheme.onSurface.withOpacity(0.12)
            : colorScheme.primary,
        isDisabled
            ? colorScheme.onSurface.withOpacity(0.38)
            : colorScheme.onPrimary,
        Colors.transparent,
      ),
      AppButtonVariant.secondary => (
        isDisabled
            ? colorScheme.onSurface.withOpacity(0.12)
            : colorScheme.secondaryContainer,
        isDisabled
            ? colorScheme.onSurface.withOpacity(0.38)
            : colorScheme.onSecondaryContainer,
        Colors.transparent,
      ),
      AppButtonVariant.ghost => (
        _isPressed ? colorScheme.surfaceContainerHighest : Colors.transparent,
        isDisabled
            ? colorScheme.onSurface.withOpacity(0.38)
            : colorScheme.onSurface,
        colorScheme.outlineVariant,
      ),
      AppButtonVariant.destructive => (
        isDisabled
            ? colorScheme.onSurface.withOpacity(0.12)
            : colorScheme.errorContainer,
        isDisabled
            ? colorScheme.onSurface.withOpacity(0.38)
            : colorScheme.onErrorContainer,
        Colors.transparent,
      ),
    };

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.isLoading) ...[
          SizedBox(
            width: iconSize,
            height: iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: fgColor,
            ),
          ),
          const SizedBox(width: 8),
        ] else if (widget.icon != null) ...[
          Icon(widget.icon, size: iconSize, color: fgColor),
          const SizedBox(width: 8),
        ],
        Text(
          widget.label,
          style: textStyle?.copyWith(
            color: fgColor,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );

    if (widget.isFullWidth) {
      content = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [content],
      );
    }

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: widget.isLoading ? null : widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: widget.isFullWidth ? double.infinity : null,
          padding: padding,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor,
              width: widget.variant == AppButtonVariant.ghost ? 1.5 : 0,
            ),
            boxShadow: widget.variant == AppButtonVariant.primary && !isDisabled
                ? [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.30),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: content,
        ),
      ),
    );
  }
}
