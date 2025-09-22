import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';

class CartHeader extends StatelessWidget {
  const CartHeader({
    super.key,
    required this.progress,
    required this.totalItems,
    required this.totalQuantity,
    required this.sugarVariety,
    required this.onClear,
  });

  final double progress;
  final int totalItems;
  final int totalQuantity;
  final int sugarVariety;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;
    final collapse = progress.clamp(0.0, 1.0);
    final accent = AppColors.orange;
    final cardOffset = lerpDouble(0, 48, collapse)!;

    return SizedBox(
      height: safeTop + 320,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: _HeaderBackground(progress: collapse, accent: accent),
          ),
          Positioned(
            top: safeTop + 12,
            left: 20,
            right: 20,
            child: Row(
              children: [
                _GlassIconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => Navigator.of(context).maybePop(),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 240),
                    child: collapse < 0.8
                        ? SizedBox(
                            key: const ValueKey('cart-title-expanded'),
                            height: 44,
                            child: Center(
                              child: Text(
                                'cart_title'.tr(),
                                style: AppTextStyle.getBoldStyle(
                                  fontSize: AppFontSize.size_18,
                                  color: AppColors.black23,
                                ),
                              ),
                            ),
                          )
                        : Align(
                            key: const ValueKey('cart-title-collapsed'),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'cart_title'.tr(),
                              style: AppTextStyle.getBoldStyle(
                                fontSize: AppFontSize.size_16,
                                color: AppColors.black23,
                              ),
                            ),
                          ),
                  ),
                ),
                _GlassIconButton(icon: Icons.delete_outline, onTap: onClear),
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            top: safeTop + 86,
            child: Transform.translate(
              offset: Offset(0, cardOffset),
              child: _SummaryCard(
                collapse: collapse,
                totalItems: totalItems,
                totalQuantity: totalQuantity,
                sugarVariety: sugarVariety,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderBackground extends StatelessWidget {
  const _HeaderBackground({required this.progress, required this.accent});

  final double progress;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final topColor = Color.lerp(
      accent.withValues(alpha: 0.5),
      AppColors.xbackgroundColor3,
      progress,
    )!;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutQuart,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [topColor, Colors.white],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -100 + (progress * 60),
            right: -40,
            child: _Halo(
              size: 220,
              colors: [accent.withValues(alpha: 0.3), Colors.transparent],
            ),
          ),
          Positioned(
            top: 140,
            left: -70,
            child: _Halo(
              size: 280,
              colors: [
                AppColors.secondPrimery.withValues(alpha: 0.2),
                Colors.transparent,
              ],
            ),
          ),
          Positioned(
            bottom: -130,
            right: -90,
            child: _Halo(
              size: 320,
              colors: [accent.withValues(alpha: 0.24), Colors.transparent],
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.4, 1.0],
                  colors: [
                    Colors.white.withValues(alpha: 0.0),
                    Colors.white.withValues(alpha: 0.18),
                    Colors.white,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.collapse,
    required this.totalItems,
    required this.totalQuantity,
    required this.sugarVariety,
  });

  final double collapse;
  final int totalItems;
  final int totalQuantity;
  final int sugarVariety;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.orange;
    final subtitleOpacity = 1 - collapse.clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: lerpDouble(28, 22, collapse)!,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.94),
                Colors.white.withValues(alpha: 0.72),
              ],
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SummaryAvatar(color: accent),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'cart_order_summary'.tr(),
                          style: AppTextStyle.getBoldStyle(
                            fontSize: AppFontSize.size_18,
                            color: AppColors.black23,
                          ),
                        ),
                        const SizedBox(height: 6),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 240),
                          opacity: subtitleOpacity,
                          child: Text(
                            'cart_intro'.tr(),
                            style: AppTextStyle.getRegularStyle(
                              fontSize: AppFontSize.size_12,
                              color: AppColors.secondPrimery,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(height: 1, color: Color(0x1FFFFFFF)),
              const SizedBox(height: 18),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _MetricPill(
                    icon: Icons.grid_view_rounded,
                    label: 'cart_metric_items'.tr(),
                    value: totalItems,
                  ),
                  _MetricPill(
                    icon: Icons.local_cafe_rounded,
                    label: 'cart_metric_total_cups'.tr(),
                    value: totalQuantity,
                  ),
                  _MetricPill(
                    icon: Icons.water_drop_rounded,
                    label: 'cart_metric_sugar_sets'.tr(),
                    value: sugarVariety,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.white.withValues(alpha: 0.78)],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.orange.withValues(alpha: 0.14),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 18, color: AppColors.orange),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _AnimatedCount(value: value),
              const SizedBox(height: 2),
              Text(
                label,
                style: AppTextStyle.getRegularStyle(
                  fontSize: AppFontSize.size_11,
                  color: AppColors.secondPrimery,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Material(
          color: Colors.white.withValues(alpha: 0.7),
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              width: 44,
              height: 44,
              child: Icon(icon, size: 20, color: AppColors.black23),
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryAvatar extends StatelessWidget {
  const _SummaryAvatar({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.28),
            color.withValues(alpha: 0.16),
          ],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
      ),
      child: Icon(Icons.receipt_long, color: color, size: 26),
    );
  }
}

class _AnimatedCount extends StatelessWidget {
  const _AnimatedCount({required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.toDouble()),
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
      builder: (context, animated, child) => Text(
        animated.toStringAsFixed(0),
        style: AppTextStyle.getBoldStyle(
          fontSize: AppFontSize.size_16,
          color: AppColors.black23,
        ),
      ),
    );
  }
}

class _Halo extends StatelessWidget {
  const _Halo({required this.size, required this.colors});

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: size * 0.1, sigmaY: size * 0.1),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: colors),
        ),
      ),
    );
  }
}
