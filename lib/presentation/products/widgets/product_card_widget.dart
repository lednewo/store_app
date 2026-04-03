import 'package:base_app/config/routes/app_routes.dart';
import 'package:base_app/domain/entities/product_entity.dart';
import 'package:base_app/domain/enum/audience_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class ProductCardWidget extends StatelessWidget {
  const ProductCardWidget({
    super.key,
    required this.product,
    this.style = ProductCardStyle.vertical,
  });

  final ProductEntity product;
  final ProductCardStyle style;

  @override
  Widget build(BuildContext context) {
    return switch (style) {
      ProductCardStyle.vertical => _VerticalCard(product: product),
      ProductCardStyle.horizontal => _HorizontalCard(product: product),
    };
  }
}

enum ProductCardStyle { vertical, horizontal }

// ─── Shared ───────────────────────────────────────────────────────────────────

void _onTap(BuildContext context, String id) {
  context.push(AppRoutes.productDetails, extra: id);
}

String _formattedPrice(double price) =>
    'R\$ ${price.toStringAsFixed(2).replaceAll('.', ',')}';

// ─── Vertical card ────────────────────────────────────────────────────────────

class _VerticalCard extends StatelessWidget {
  const _VerticalCard({required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _onTap(context, product.id),
      child: Ink(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant.withAlpha(120)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProductImage.vertical(
              url: product.urlImages.firstOrNull,
              colorScheme: colorScheme,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${product.brand} · ${product.model}',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formattedPrice(product.price),
                        style: textTheme.titleSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _AudienceBadge(audience: product.audience),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Horizontal card ──────────────────────────────────────────────────────────

class _HorizontalCard extends StatelessWidget {
  const _HorizontalCard({required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _onTap(context, product.id),
      child: Ink(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colorScheme.outlineVariant.withAlpha(120)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              _ProductImage.horizontal(
                url: product.urlImages.firstOrNull,
                colorScheme: colorScheme,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _AudienceBadge(audience: product.audience),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${product.brand} · ${product.model}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formattedPrice(product.price),
                      style: textTheme.titleSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                size: 18,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Product image ────────────────────────────────────────────────────────────

class _ProductImage extends StatelessWidget {
  const _ProductImage({
    required this.url,
    required this.colorScheme,
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  factory _ProductImage.vertical({
    required String? url,
    required ColorScheme colorScheme,
  }) => _ProductImage(
    url: url,
    colorScheme: colorScheme,
    width: double.infinity,
    height: 160,
    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
  );

  factory _ProductImage.horizontal({
    required String? url,
    required ColorScheme colorScheme,
  }) => _ProductImage(
    url: url,
    colorScheme: colorScheme,
    width: 80,
    height: 80,
    borderRadius: BorderRadius.circular(10),
  );

  final String? url;
  final ColorScheme colorScheme;
  final double width;
  final double height;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final placeholder = _Placeholder(
      colorScheme: colorScheme,
      width: width,
      height: height,
      borderRadius: borderRadius,
    );

    if (url == null || url!.isEmpty) return placeholder;

    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        width: width,
        height: height,
        child: Image.network(
          url!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => placeholder,
          loadingBuilder: (_, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _Placeholder(
              colorScheme: colorScheme,
              width: width,
              height: height,
              borderRadius: borderRadius,
              isLoading: true,
            );
          },
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({
    required this.colorScheme,
    required this.width,
    required this.height,
    required this.borderRadius,
    this.isLoading = false,
  });

  final ColorScheme colorScheme;
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: borderRadius,
      ),
      child: Center(
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.primary.withAlpha(100),
                ),
              )
            : Icon(
                Icons.checkroom_outlined,
                size: 28,
                color: colorScheme.onSurfaceVariant.withAlpha(100),
              ),
      ),
    );
  }
}

// ─── Audience badge ───────────────────────────────────────────────────────────

class _AudienceBadge extends StatelessWidget {
  const _AudienceBadge({required this.audience});

  final AudienceEnum audience;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        audience.label,
        style: textTheme.labelSmall?.copyWith(
          color: colorScheme.onSecondaryContainer,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
