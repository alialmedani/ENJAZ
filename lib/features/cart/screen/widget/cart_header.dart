import 'dart:ui';
import 'package:flutter/material.dart';
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
      height: safeTop + 260,
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 320),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.lerp(
                      accent.withValues(alpha: 0.45),
                      Colors.white,
                      collapse,
                    )!,
                    AppColors.xbackgroundColor,
                  ],
                ),
              ),
            ),
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
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: 1 - collapse,
                    child: Center(
                      child: Text(
                        'Cart',
                        style: AppTextStyle.getBoldStyle(
                          fontSize: AppFontSize.size_18,
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
            bottom: 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 240),
              opacity: 1 - collapse * 0.9,
              child: Transform.translate(
                offset: Offset(0, 22 * collapse),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        color: Colors.white.withValues(alpha: 0.7),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order summary',
                            style: AppTextStyle.getBoldStyle(
                              fontSize: AppFontSize.size_16,
                              color: AppColors.black23,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'You are moments away from fresh coffee.',
                            style: AppTextStyle.getRegularStyle(
                              fontSize: AppFontSize.size_12,
                              color: AppColors.secondPrimery,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: const [
                              _MetricChip(
                                icon: Icons.coffee_outlined,
                                label: 'Items',
                              ),
                              _MetricChip(
                                icon: Icons.local_drink_outlined,
                                label: 'Total cups',
                              ),
                              _MetricChip(
                                icon: Icons.water_drop_outlined,
                                label: 'Sugar sets',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
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

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    // القيم الحقيقية بتنعرض من CartScreen => مش لازم نكرر هنا
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyE5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.orange),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // placeholder—القيم تعرض فوق مع الـ summary
              Text(
                '-',
                style: AppTextStyle.getBoldStyle(
                  fontSize: AppFontSize.size_13,
                  color: AppColors.black23,
                ),
              ),
              Text(
                label,
                style: AppTextStyle.getRegularStyle(
                  fontSize: AppFontSize.size_10,
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
