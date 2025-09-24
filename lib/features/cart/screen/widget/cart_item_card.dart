import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/enum/enum.dart';
import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';
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
    final rawTitle = (item.drink.name ?? item.drink.id ?? '').trim();
    final displayTitle = rawTitle.isEmpty
        ? 'cart_item_unknown_drink'.tr()
        : rawTitle;
    final alias = rawTitle.isNotEmpty ? rawTitle[0].toUpperCase() : '?';
    final sugarLabel = _sugarLevelLabel(
      _percentageToSugarLevel(item.sugarPercentage),
    ).tr();

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.88, end: 1),
      duration: Duration(milliseconds: 360 + index * 60),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, (1 - value) * 28),
          child: Transform.scale(
            scale: value,
            alignment: Alignment.topCenter,
            child: child,
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.95),
                  Colors.white.withValues(alpha: 0.78),
                ],
              ),
              border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 24,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ItemThumbnail(item: item, alias: alias),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    displayTitle,
                                    style: AppTextStyle.getBoldStyle(
                                      fontSize: AppFontSize.size_16,
                                      color: AppColors.black23,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item.drink.description ?? 'cart_intro'.tr(),
                                    style: AppTextStyle.getRegularStyle(
                                      fontSize: AppFontSize.size_12,
                                      color: AppColors.secondPrimery,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            _RemoveButton(onTap: onRemove),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 10,
                          runSpacing: 8,
                          children: [
                            _InfoChip(
                              icon: Icons.straighten_rounded,
                              label: 'cart_item_size'.tr(
                                namedArgs: {'size': item.size},
                              ),
                            ),
                            _InfoChip(
                              icon: Icons.water_drop_rounded,
                              label: 'cart_item_sugar'.tr(
                                namedArgs: {'level': sugarLabel},
                              ),
                            ),
                            if (item.notes?.isNotEmpty == true)
                              _InfoChip(
                                icon: Icons.edit_note_rounded,
                                label: item.notes!,
                              ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Divider(height: 1, color: Color(0x1FFFFFFF)),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _QuantityControl(
                              quantity: item.quantity,
                              onDecrement: item.quantity > 1
                                  ? () => onQuantityChanged(item.quantity - 1)
                                  : null,
                              onIncrement: () =>
                                  onQuantityChanged(item.quantity + 1),
                            ),
                            _Badge(label: sugarLabel),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ItemThumbnail extends StatelessWidget {
  const _ItemThumbnail({required this.item, required this.alias});

  final CartItemModel item;
  final String alias;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 96,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.orange.withValues(alpha: 0.2),
            AppColors.orange.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: CachedImage(
          imageUrl:
              'https://task.jasim-erp.com/api/dms/file/get/${item.drink.id}/?entitytype=1',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

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
        const SizedBox(width: 14),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeOut,
          child: Text(
            '$quantity',
            key: ValueKey<int>(quantity),
            style: AppTextStyle.getBoldStyle(
              fontSize: AppFontSize.size_18,
              color: AppColors.black23,
            ),
          ),
        ),
        const SizedBox(width: 14),
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
    final disabled = onTap == null;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: disabled ? 0.4 : 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              colors: [
                AppColors.orange,
                AppColors.orange.withValues(alpha: 0.8),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.orange.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.orange, size: 20),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [AppColors.orange, AppColors.white.withValues(alpha: 0.6)],
        ),
        border: Border.all(color: AppColors.orange.withValues(alpha: 0.85)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              label,
              style: AppTextStyle.getRegularStyle(
                fontSize: AppFontSize.size_12,
                color: AppColors.black23,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RemoveButton extends StatelessWidget {
  const _RemoveButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'cart_clear_action'.tr(),
      child: ClipOval(
        child: Material(
          color: Colors.red.withValues(alpha: 0.14),
          child: InkWell(
            onTap: onTap,
            child: const SizedBox(
              width: 36,
              height: 36,
              child: Icon(Icons.close_rounded, size: 18, color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            AppColors.orange.withValues(alpha: 0.9),
            AppColors.orange.withValues(alpha: 0.7),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.orange.withValues(alpha: 0.3),
            blurRadius: 14,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Text(
        label,
        style: AppTextStyle.getBoldStyle(
          fontSize: AppFontSize.size_12,
          color: Colors.white,
        ),
      ),
    );
  }
}

// class _MiniBadge extends StatelessWidget {
//   const _MiniBadge({required this.text});

//   final String text;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(14),
//         color: Colors.white.withValues(alpha: 0.9),
//       ),
//       child: Text(
//         text,
//         style: AppTextStyle.getBoldStyle(
//           fontSize: AppFontSize.size_11,
//           color: AppColors.orange,
//         ),
//       ),
//     );
//   }
// }

SugarLevel _percentageToSugarLevel(double value) {
  if (value <= 0) return SugarLevel.none;
  if (value <= 0.25) return SugarLevel.light;
  if (value <= 0.5) return SugarLevel.medium;
  return SugarLevel.high;
}

String _sugarLevelLabel(SugarLevel level) {
  switch (level) {
    case SugarLevel.none:
      return 'sugar_none';
    case SugarLevel.light:
      return 'sugar_light';
    case SugarLevel.medium:
      return 'sugar_medium';
    case SugarLevel.high:
      return 'sugar_high';
  }
}
