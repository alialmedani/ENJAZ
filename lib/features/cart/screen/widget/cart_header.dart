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

    return SizedBox(
      height: safeTop + 300,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _HeaderBackground(progress: collapse, accent: accent),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: safeTop + 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _Toolbar(
                    collapse: collapse,
                    onBack: () => Navigator.of(context).maybePop(),
                    onClear: onClear,
                  ),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _SummaryStage(
                      collapse: collapse,
                      totalItems: totalItems,
                      totalQuantity: totalQuantity,
                      sugarVariety: sugarVariety,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.collapse,
    required this.onBack,
    required this.onClear,
  });

  final double collapse;
  final VoidCallback onBack;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _GlassIconButton(icon: Icons.arrow_back_ios_new_rounded, onTap: onBack),
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
    );
  }
}

class _SummaryStage extends StatelessWidget {
  const _SummaryStage({
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
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: collapse),
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final slide = lerpDouble(0, 48, value)!;
        final scale = lerpDouble(1.0, 0.94, value)!;
        final haloOpacity = lerpDouble(1.0, 0.25, value)!;

        return Stack(
          alignment: Alignment.topCenter,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Opacity(
                opacity: haloOpacity,
                child: _SummaryAura(accent: AppColors.orange),
              ),
            ),
            Transform.translate(
              offset: Offset(0, slide),
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.topCenter,
                child: _SummaryCard(
                  collapse: value,
                  totalItems: totalItems,
                  totalQuantity: totalQuantity,
                  sugarVariety: sugarVariety,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SummaryAura extends StatelessWidget {
  const _SummaryAura({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: const Alignment(-0.8, -0.4),
            child: _Halo(
              size: 220,
              colors: [accent.withValues(alpha: 0.3), Colors.transparent],
            ),
          ),
          Align(
            alignment: const Alignment(0.9, -0.2),
            child: _Halo(
              size: 160,
              colors: [
                AppColors.secondPrimery.withValues(alpha: 0.22),
                Colors.transparent,
              ],
            ),
          ),
          Align(
            alignment: const Alignment(0.0, 0.8),
            child: _Halo(
              size: 240,
              colors: [accent.withValues(alpha: 0.18), Colors.transparent],
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
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: progress),
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutQuart,
        builder: (context, value, child) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Align(
                alignment: Alignment(
                  lerpDouble(0.4, 0.9, value)!,
                  lerpDouble(-1.2, -0.6, value)!,
                ),
                child: Transform.translate(
                  offset: Offset(
                    lerpDouble(0, -30, value)!,
                    lerpDouble(-100, -60, value)!,
                  ),
                  child: _Halo(
                    size: 220,
                    colors: [accent.withValues(alpha: 0.3), Colors.transparent],
                  ),
                ),
              ),
              Align(
                alignment: Alignment(
                  lerpDouble(-1.2, -0.8, value)!,
                  lerpDouble(0.3, 0.6, value)!,
                ),
                child: Transform.translate(
                  offset: Offset(
                    lerpDouble(-60, -40, value)!,
                    lerpDouble(40, 20, value)!,
                  ),
                  child: _Halo(
                    size: 280,
                    colors: [
                      AppColors.secondPrimery.withValues(alpha: 0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment(
                  lerpDouble(1.2, 1.0, value)!,
                  lerpDouble(1.2, 0.9, value)!,
                ),
                child: Transform.translate(
                  offset: Offset(
                    lerpDouble(60, 20, value)!,
                    lerpDouble(80, 40, value)!,
                  ),
                  child: _Halo(
                    size: 320,
                    colors: [
                      accent.withValues(alpha: 0.24),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              if (child != null) child!,
            ],
          );
        },
        child: SizedBox.expand(
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
            horizontal: 22,
            vertical: lerpDouble(24, 18, collapse)!,
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
              const SizedBox(height: 18),
              const Divider(height: 1, color: Color(0x1FFFFFFF)),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
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
                  // _MetricPill(
                  //   icon: Icons.water_drop_rounded,
                  //   label: 'cart_metric_sugar_sets'.tr(),
                  //   value: sugarVariety,
                  // ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.orange.withValues(alpha: 0.14),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 16, color: AppColors.orange),
          ),
          const SizedBox(width: 10),
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
      width: 48,
      height: 48,
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
      child: Icon(Icons.receipt_long, color: color, size: 24),
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
          fontSize: AppFontSize.size_15,
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
