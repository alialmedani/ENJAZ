// lib/features/profile/widgets/profile_arc_header.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';

import 'animated_dark_header_bg.dart';
import 'fade_slide_in.dart';
 import 'segmented_tabs.dart';

class ProfileArcHeader extends StatelessWidget {
  final TabController controller;
  final String title;
  const ProfileArcHeader({super.key, required this.controller, required this.title});

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
                        style: AppTextStyle.getBoldStyle(
                          fontSize: AppFontSize.size_18,
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
                child: SegmentedTabs(
                  controller: controller,
                  tabs: ['tab_overview'.tr(), 'tab_history'.tr()],
                  height: 46,
                  outerRadius: 14,
                  pillRadius: 10,
                  backgroundColor: AppColors.xbackgroundColor3,
                  borderColor: const Color(0xFFEFE4DE),
                  unselectedTextColor: AppColors.secondPrimery,
                  pillGradient: [AppColors.darkAccentColor, AppColors.xorangeColor],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
