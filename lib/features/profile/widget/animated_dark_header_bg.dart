// lib/features/profile/widgets/animated_dark_header_bg.dart
import 'package:flutter/material.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';

class AnimatedDarkHeaderBackground extends StatefulWidget {
  final double height;
  const AnimatedDarkHeaderBackground({super.key, required this.height});
  @override
  State<AnimatedDarkHeaderBackground> createState() =>
      _AnimatedDarkHeaderBackgroundState();
}

class _AnimatedDarkHeaderBackgroundState
    extends State<AnimatedDarkHeaderBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final t = _ctrl.value;
        return Container(
          height: widget.height,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.darkPrimaryColor,
                AppColors.darkSecondaryColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              _bubble(
                left: 33 + 8 * t,
                top: 38,
                size: 52 + 8 * t,
                color: AppColors.darkAccentColor.withValues(alpha: .20),
              ),
              _bubble(
                right: 28,
                top: 38 + 6 * (1 - t),
                size: 44,
                color: AppColors.xpurpleColor.withValues(alpha: .18),
              ),
              _bubble(
                left: 140,
                bottom: 22,
                size: 36 + 10 * (1 - t),
                color: AppColors.xorangeColor.withValues(alpha: .20),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _bubble({
    double? left,
    double? right,
    double? top,
    double? bottom,
    required double size,
    required Color color,
  }) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
