import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';

class EmptyCartView extends StatelessWidget {
  const EmptyCartView({super.key, required this.onBrowse});

  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.orange;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.88, end: 1),
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 34,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.95),
                      Colors.white.withValues(alpha: 0.75),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 26,
                      offset: const Offset(0, 18),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Halo(accent: accent),
                    const SizedBox(height: 24),
                    Text(
                      'empty_cart_title'.tr(),
                      style: AppTextStyle.getBoldStyle(
                        fontSize: AppFontSize.size_20,
                        color: AppColors.black23,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'empty_cart_subtitle'.tr(),
                      style: AppTextStyle.getRegularStyle(
                        fontSize: AppFontSize.size_13,
                        color: AppColors.secondPrimery,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 14),
                        _PrimaryButton(
                          label: 'empty_cart_browse'.tr(),
                          onTap: onBrowse,
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
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.orange;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.95),
                    Colors.white.withValues(alpha: 0.78),
                  ],
                ),
                border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 26,
                    offset: const Offset(0, 18),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline_rounded, size: 58, color: accent),
                  const SizedBox(height: 18),
                  Text(
                    message,
                    style: AppTextStyle.getRegularStyle(
                      fontSize: AppFontSize.size_14,
                      color: AppColors.black23,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  _PrimaryButton(label: 'common_retry'.tr(), onTap: onRetry),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Halo extends StatelessWidget {
  const _Halo({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 132,
          height: 132,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [accent.withValues(alpha: 0.18), Colors.transparent],
            ),
          ),
        ),
        Container(
          width: 86,
          height: 86,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.92),
            border: Border.all(color: Colors.white.withValues(alpha: 0.7)),
          ),
          child: Icon(Icons.shopping_cart_outlined, size: 38, color: accent),
        ),
      ],
    );
  }
}

class _GhostButton extends StatelessWidget {
  const _GhostButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.orange,
        side: BorderSide(color: AppColors.orange.withValues(alpha: 0.5)),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      child: Text(
        label,
        style: AppTextStyle.getBoldStyle(
          fontSize: AppFontSize.size_13,
          color: AppColors.orange,
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.orange,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 10,
        shadowColor: AppColors.orange.withValues(alpha: 0.4),
      ),
      child: Text(
        label,
        style: AppTextStyle.getBoldStyle(
          fontSize: AppFontSize.size_13,
          color: Colors.white,
        ),
      ),
    );
  }
}
