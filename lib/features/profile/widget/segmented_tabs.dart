// lib/features/profile/widgets/segmented_tabs.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';

class SegmentedTabs extends StatelessWidget {
  final TabController controller;
  final List<String> tabs;
  final double height;
  final double outerRadius;
  final double pillRadius;
  final EdgeInsets padding;
  final List<Color> pillGradient;
  final Color backgroundColor;
  final Color borderColor;
  final Color unselectedTextColor;

  const SegmentedTabs({
    super.key,
    required this.controller,
    required this.tabs,
    this.height = 46,
    this.outerRadius = 14,
    this.pillRadius = 10,
    this.padding = const EdgeInsets.all(6),
    this.pillGradient = const [],
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.borderColor = const Color(0xFFEFE4DE),
    this.unselectedTextColor = const Color(0xFF5D5B66),
  });

  @override
  Widget build(BuildContext context) {
    final anim = controller.animation ?? controller;
    return LayoutBuilder(
      builder: (context, c) {
        final pillWidth = (c.maxWidth - padding.horizontal) / tabs.length;
        return Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(outerRadius),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .06),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: anim,
                builder: (_, __) {
                  final v = (controller.index + controller.offset).clamp(
                    0.0,
                    (tabs.length - 1).toDouble(),
                  );
                  final left = padding.left + (v * pillWidth);
                  return AnimatedPositioned(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    left: left,
                    top: padding.top,
                    width: pillWidth,
                    height: height - padding.vertical,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: pillGradient.isNotEmpty
                              ? pillGradient
                              : [
                                  AppColors.darkAccentColor,
                                  AppColors.xorangeColor,
                                ],
                        ),
                        borderRadius: BorderRadius.circular(pillRadius),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.darkAccentColor.withValues(
                              alpha: .22,
                            ),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Row(
                children: List.generate(tabs.length, (i) {
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        controller.animateTo(
                          i,
                          duration: const Duration(milliseconds: 240),
                          curve: Curves.easeOutCubic,
                        );
                      },
                      child: Center(
                        child: _AnimatedTabText(
                          index: i,
                          text: tabs[i],
                          controller: controller,
                          unselected: unselectedTextColor,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AnimatedTabText extends StatelessWidget {
  final int index;
  final String text;
  final TabController controller;
  final Color unselected;

  const _AnimatedTabText({
    required this.index,
    required this.text,
    required this.controller,
    required this.unselected,
  });

  @override
  Widget build(BuildContext context) {
    final anim = controller.animation ?? controller;
    return AnimatedBuilder(
      animation: anim,
      builder: (_, __) {
        final dist = (controller.index + controller.offset) - index;
        final t = (1.0 - dist.abs()).clamp(0.0, 1.0);
        final color = Color.lerp(unselected, Colors.white, t);
        final fw = t > .5 ? FontWeight.w800 : FontWeight.w600;
        return AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 140),
          style: TextStyle(
            color: color,
            fontSize: AppFontSize.size_14,
            fontWeight: fw,
          ),
          child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
        );
      },
    );
  }
}
