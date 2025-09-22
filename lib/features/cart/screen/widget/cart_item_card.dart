import 'package:flutter/material.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';
import 'package:enjaz/core/constant/enum/enum.dart';
import 'package:enjaz/core/ui/widgets/cached_image.dart';
import 'package:enjaz/features/cart/data/model/cart_item_model.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.item,
    required this.index,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  final CartItemModel item;
  final int index;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final alias = (item.drink.name ?? item.drink.id ?? '?').trim().isNotEmpty
        ? (item.drink.name ?? item.drink.id ?? '?').trim()[0].toUpperCase()
        : '?';
    final sugarLabel = _sugarLevelLabel(
      _percentageToSugarLevel(item.sugarPercentage),
    );

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 320 + index * 70),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, (1 - value) * 20),
          child: child,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: AppColors.greyE5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: SizedBox(
                  width: 86,
                  height: 86,
                  child: CachedImage(
                    imageUrl:
                        'https://task.jasim-erp.com/api/dms/file/get/${item.drink.id}/?entitytype=1',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.drink.name ?? 'Unknown drink',
                                style: AppTextStyle.getBoldStyle(
                                  fontSize: AppFontSize.size_16,
                                  color: AppColors.black23,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Size ${item.size} | Sugar $sugarLabel',
                                style: AppTextStyle.getRegularStyle(
                                  fontSize: AppFontSize.size_12,
                                  color: AppColors.secondPrimery,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: onRemove,
                          icon: const Icon(Icons.close_rounded, size: 18),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints.tightFor(
                            width: 32,
                            height: 32,
                          ),
                          color: Colors.white,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.red.withValues(alpha: 0.12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _QuantityControl(
                          quantity: item.quantity,
                          onDecrement: item.quantity > 1
                              ? () => onQuantityChanged(item.quantity - 1)
                              : null,
                          onIncrement: () =>
                              onQuantityChanged(item.quantity + 1),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.xbackgroundColor3,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.orange.withValues(
                                    alpha: 0.18,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  alias,
                                  style: AppTextStyle.getBoldStyle(
                                    fontSize: AppFontSize.size_12,
                                    color: AppColors.orange,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Sugar $sugarLabel',
                                style: AppTextStyle.getRegularStyle(
                                  fontSize: AppFontSize.size_12,
                                  color: AppColors.black23,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

// ==== Helpers ====

class _QuantityControl extends StatelessWidget {
  const _QuantityControl({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  final int quantity;
  final VoidCallback? onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _QuantityButton(icon: Icons.remove_rounded, onTap: onDecrement),
        const SizedBox(width: 12),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text(
            '$quantity',
            key: ValueKey<int>(quantity),
            style: AppTextStyle.getBoldStyle(
              fontSize: AppFontSize.size_16,
              color: AppColors.black23,
            ),
          ),
        ),
        const SizedBox(width: 12),
        _QuantityButton(icon: Icons.add_rounded, onTap: onIncrement),
      ],
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: onTap == null ? 0.4 : 1,
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.orange,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 18, color: Colors.white),
        ),
      ),
    );
  }
}

SugarLevel _percentageToSugarLevel(double value) {
  if (value <= 0) return SugarLevel.none;
  if (value <= 0.25) return SugarLevel.light;
  if (value <= 0.5) return SugarLevel.medium;
  return SugarLevel.high;
}

String _sugarLevelLabel(SugarLevel level) {
  switch (level) {
    case SugarLevel.none:
      return 'None';
    case SugarLevel.light:
      return 'Light';
    case SugarLevel.medium:
      return 'Medium';
    case SugarLevel.high:
      return 'High';
  }
}
