import 'package:base_app/config/routes/app_routes.dart';
import 'package:base_app/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductHorizontalCardWidget extends StatelessWidget {
  const ProductHorizontalCardWidget({
    super.key,
    required this.product,
  });

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: 160,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => context.push(
          AppRoutes.productDetails,
          extra: product.id,
        ),
        child: Ink(
          decoration: BoxDecoration(
            color: colorScheme.tertiary,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: colorScheme.outlineVariant.withAlpha(120),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CardImage(
                url: product.urlImages.firstOrNull,
                colorScheme: colorScheme,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
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
                        color: colorScheme.onInverseSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'R\$ ${product.price.toStringAsFixed(2).replaceAll('.', ',')}',
                      style: textTheme.titleSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardImage extends StatelessWidget {
  const _CardImage({
    required this.url,
    required this.colorScheme,
  });

  final String? url;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    const height = 110.0;
    const borderRadius = BorderRadius.vertical(top: Radius.circular(14));

    final placeholder = Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: colorScheme.inversePrimary,
        borderRadius: borderRadius,
      ),
      child: Center(
        child: Icon(
          Icons.checkroom_outlined,
          size: 28,
          color: colorScheme.onInverseSurface.withAlpha(100),
        ),
      ),
    );

    if (url == null || url!.isEmpty) return placeholder;

    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: Image.network(
          url!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => placeholder,
        ),
      ),
    );
  }
}
