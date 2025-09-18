import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';

import 'fade_slide_in.dart';

class ProfileArcHeader extends StatelessWidget {
  final TabController controller;
  final String title;

  const ProfileArcHeader({
    super.key,
    required this.controller,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return SizedBox(
      height: 168,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedDarkHeaderBackground(height: 132 + top),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(top: top + 12, left: 16, right: 16),
              child: Row(
                children: [
                  Expanded(
                    child: FadeSlideIn(
                      delay: const Duration(milliseconds: 40),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: AppFontSize.size_18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.darkSubHeadingColor1,
                        ),
                      ),
                    ),
                  ),
                  FadeScaleIconButton(
                    icon: Icons.settings_outlined,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('settings_soon'.tr())),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: -22,
            child: FadeSlideIn(
              delay: const Duration(milliseconds: 120),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.xbackgroundColor2,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.10),
                      blurRadius: 14,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(6),
                child: SegmentedTabBar(controller: controller),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
                color: AppColors.darkAccentColor.withOpacity(.20),
              ),
              _bubble(
                right: 28,
                top: 38 + 6 * (1 - t),
                size: 44,
                color: AppColors.xpurpleColor.withOpacity(.18),
              ),
              _bubble(
                left: 140,
                bottom: 22,
                size: 36 + 10 * (1 - t),
                color: AppColors.xorangeColor.withOpacity(.20),
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
      child: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 600),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}

class SegmentedTabBar extends StatelessWidget {
  final TabController controller;
  const SegmentedTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final tabs = ['tab_overview'.tr(), 'tab_history'.tr()];
    const pillRadius = 10.0;

    return LayoutBuilder(
      builder: (context, c) {
        final pillWidth = (c.maxWidth - 12) / tabs.length;
        final anim = controller.animation ?? controller;

        return Container(
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.xbackgroundColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFEFE4DE)),
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
                  final left = 6 + (v * pillWidth);
                  return AnimatedPositioned(
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeOutCubic,
                    left: left,
                    top: 6,
                    width: pillWidth,
                    height: 34,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.darkAccentColor,
                            AppColors.xorangeColor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(pillRadius),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.darkAccentColor.withOpacity(0.25),
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
                          duration: const Duration(milliseconds: 260),
                          curve: Curves.easeOutCubic,
                        );
                      },
                      child: AnimatedBuilder(
                        animation: anim,
                        builder: (_, __) {
                          final dist =
                              (controller.index + controller.offset) - i;
                          final t = (1.0 - dist.abs()).clamp(0.0, 1.0);
                          final color = Color.lerp(
                            AppColors.secondPrimery,
                            Colors.white,
                            t,
                          );
                          final fw = t > .5 ? FontWeight.w800 : FontWeight.w600;
                          return Center(
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 140),
                              style: TextStyle(
                                color: color,
                                fontSize: AppFontSize.size_14,
                                fontWeight: fw,
                              ),
                              child: Text(tabs[i]),
                            ),
                          );
                        },
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

class FadeScaleIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  const FadeScaleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  State<FadeScaleIconButton> createState() => _FadeScaleIconButtonState();
}

class _FadeScaleIconButtonState extends State<FadeScaleIconButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapCancel: () => _ctrl.reverse(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      child: ScaleTransition(
        scale: Tween<double>(
          begin: 1.0,
          end: 0.92,
        ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic)),
        child: Icon(widget.icon, color: AppColors.darkSubHeadingColor1),
      ),
    );
  }
}
