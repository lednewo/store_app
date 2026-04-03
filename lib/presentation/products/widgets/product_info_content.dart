import 'package:base_app/common/utils/login_detect.dart';
import 'package:base_app/common/widgets/app_button.dart';
import 'package:base_app/domain/entities/product_entity.dart';
import 'package:base_app/domain/enum/status_enum.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProductInfoContent extends StatelessWidget {
  const ProductInfoContent({
    required this.product,
    super.key,
    this.onEdit,
    this.onDelete,
  });

  final ProductEntity product;
  final void Function()? onEdit;
  final void Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ImageCarousel(images: product.urlImages),
            const SizedBox(height: 20),
            _ProductHeader(product: product),
            const SizedBox(height: 20),
            _Divider(),
            const SizedBox(height: 20),
            _InfoSection(product: product, l10n: l10n),
            const SizedBox(height: 20),
            if (product.sizes.isNotEmpty) ...[
              _Divider(),
              const SizedBox(height: 20),
              _SizeSelector(sizes: product.sizes, l10n: l10n),
            ],
            if (product.colors.isNotEmpty) ...[
              const SizedBox(height: 20),
              _ColorSelector(colors: product.colors, l10n: l10n),
            ],
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _BottomAction(
        product: product,
        onEdit: onEdit,
        onDelete: onDelete,
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _ProductHeader extends StatelessWidget {
  const _ProductHeader({required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                product.name,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(width: 12),
            _StatusBadge(status: product.status),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${product.brand} · ${product.model}',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'R\$ ${product.price.toStringAsFixed(2).replaceAll('.', ',')}',
          style: textTheme.headlineMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// ─── Status badge ─────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final StatusEnum status;

  Color _color(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (status) {
      StatusEnum.active => const Color(0xFF2E7D32),
      StatusEnum.inactive => colorScheme.error,
      _ => const Color(0xFFE65100),
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = _color(context);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(100)),
      ),
      child: Text(
        status.label,
        style: textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─── Info section ─────────────────────────────────────────────────────────────

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.product, required this.l10n});

  final ProductEntity product;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.productDetailsInfoSectionLabel,
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        _InfoRow(
          label: l10n.createProductDescriptionLabel,
          value: product.description,
        ),
        const SizedBox(height: 8),
        _InfoRow(
          label: l10n.createProductGenderLabel,
          value: product.gender.value,
        ),
        const SizedBox(height: 8),
        _InfoRow(
          label: l10n.createProductAudienceLabel,
          value: product.audience.label,
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(value, style: textTheme.bodySmall),
        ),
      ],
    );
  }
}

// ─── Size selector ────────────────────────────────────────────────────────────

class _SizeSelector extends StatefulWidget {
  const _SizeSelector({required this.sizes, required this.l10n});

  final List<int> sizes;
  final AppLocalizations l10n;

  @override
  State<_SizeSelector> createState() => _SizeSelectorState();
}

class _SizeSelectorState extends State<_SizeSelector> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.l10n.productDetailsSizesLabel,
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(widget.sizes.length, (i) {
            final isSelected = _selectedIndex == i;
            return GestureDetector(
              onTap: () => setState(() {
                _selectedIndex = isSelected ? null : i;
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? colorScheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.outlineVariant,
                  ),
                ),
                child: Text(
                  widget.sizes[i].toString(),
                  style: textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ─── Color selector ───────────────────────────────────────────────────────────

class _ColorSelector extends StatefulWidget {
  const _ColorSelector({required this.colors, required this.l10n});

  final List<String> colors;
  final AppLocalizations l10n;

  @override
  State<_ColorSelector> createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<_ColorSelector> {
  int? _selectedIndex;

  static const _colorMap = <String, Color>{
    'preto': Color(0xFF1A1A1A),
    'black': Color(0xFF1A1A1A),
    'branco': Color(0xFFF5F5F5),
    'white': Color(0xFFF5F5F5),
    'vermelho': Color(0xFFE53935),
    'red': Color(0xFFE53935),
    'azul': Color(0xFF1E88E5),
    'blue': Color(0xFF1E88E5),
    'verde': Color(0xFF43A047),
    'green': Color(0xFF43A047),
    'amarelo': Color(0xFFFDD835),
    'yellow': Color(0xFFFDD835),
    'laranja': Color(0xFFFB8C00),
    'orange': Color(0xFFFB8C00),
    'rosa': Color(0xFFE91E8C),
    'pink': Color(0xFFE91E8C),
    'roxo': Color(0xFF8E24AA),
    'purple': Color(0xFF8E24AA),
    'cinza': Color(0xFF757575),
    'gray': Color(0xFF757575),
    'grey': Color(0xFF757575),
    'marrom': Color(0xFF6D4C41),
    'brown': Color(0xFF6D4C41),
    'bege': Color(0xFFF5F0E8),
    'beige': Color(0xFFF5F0E8),
  };

  Color _resolveColor(String name) =>
      _colorMap[name.toLowerCase()] ?? const Color(0xFF9E9E9E);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.l10n.productDetailsColorsLabel,
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(widget.colors.length, (i) {
            final isSelected = _selectedIndex == i;
            final dotColor = _resolveColor(widget.colors[i]);

            return GestureDetector(
              onTap: () => setState(() {
                _selectedIndex = isSelected ? null : i;
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primaryContainer
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.outlineVariant,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: dotColor,
                        border: Border.all(
                          color: colorScheme.outlineVariant,
                          width: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.colors[i],
                      style: textTheme.labelMedium?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: isSelected
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ─── Bottom action ────────────────────────────────────────────────────────────

class _BottomAction extends StatelessWidget {
  const _BottomAction({required this.product, this.onEdit, this.onDelete});

  final ProductEntity product;
  final void Function()? onEdit;
  final void Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant.withAlpha(80)),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.paddingOf(context).bottom + 12,
      ),
      child: ValueListenableBuilder<LoginType>(
        valueListenable: LoginDetect.loginTypeNotifier,
        builder: (context, _, __) {
          if (LoginDetect.isVendedor) {
            return Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Editar produto',
                    icon: Icons.edit_outlined,
                    variant: AppButtonVariant.secondary,
                    isFullWidth: true,
                    onTap: onEdit,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    label: 'Excluir produto',
                    icon: Icons.delete_outline,
                    variant: AppButtonVariant.destructive,
                    isFullWidth: true,
                    onTap: onDelete,
                  ),
                ),
              ],
            );
          }
          return AppButton(
            label: 'Adicionar ao carrinho',
            icon: Icons.shopping_bag_outlined,
            isFullWidth: true,
            onTap: () {},
          );
        },
      ),
    );
  }
}

// ─── Image carousel ───────────────────────────────────────────────────────────
class _ImageCarousel extends StatefulWidget {
  const _ImageCarousel({required this.images});

  final List<String> images;

  @override
  State<_ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<_ImageCarousel> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (widget.images.isEmpty) {
      return _EmptyCarousel(colorScheme: colorScheme);
    }

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 280,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (i) => setState(() => _currentIndex = i),
              itemBuilder: (context, i) => Image.network(
                widget.images[i],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    _BrokenImage(colorScheme: colorScheme),
              ),
            ),
          ),
        ),
        if (widget.images.length > 1) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.images.length,
              (i) => GestureDetector(
                onTap: () => _pageController.animateToPage(
                  i,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _currentIndex == i ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: _currentIndex == i
                        ? colorScheme.primary
                        : colorScheme.outlineVariant,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _EmptyCarousel extends StatelessWidget {
  const _EmptyCarousel({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: 40,
            color: colorScheme.outline,
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.productDetailsNoImages,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}

class _BrokenImage extends StatelessWidget {
  const _BrokenImage({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.broken_image_outlined,
          size: 40,
          color: colorScheme.outline,
        ),
      ),
    );
  }
}

// ─── Divider ──────────────────────────────────────────────────────────────────

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Theme.of(context).colorScheme.outlineVariant.withAlpha(100),
      height: 1,
    );
  }
}
