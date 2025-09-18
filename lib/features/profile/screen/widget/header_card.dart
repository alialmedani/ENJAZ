// lib/features/profile/widgets/header_card.dart
import 'package:flutter/material.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/app_padding/app_padding.dart';
import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/model/user_profile.dart';

class HeaderCard extends StatelessWidget {
  final UserProfile profile;
  const HeaderCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPaddingSize.padding_16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppPaddingSize.padding_12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppColors.darkAccentColor, AppColors.xorangeColor],
                  ),
                ),
              ),
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.xbackgroundColor,
                backgroundImage: profile.avatarUrl != null
                    ? NetworkImage(profile.avatarUrl!)
                    : null,
                child: profile.avatarUrl == null
                    ? Icon(
                        Icons.person,
                        color: AppColors.secondPrimery,
                        size: 28,
                      )
                    : null,
              ),
            ],
          ),
          const SizedBox(width: AppPaddingSize.padding_12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: AppTextStyle.getBoldStyle(
                    fontSize: AppFontSize.size_16,
                    color: AppColors.black23,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'floor_office'.tr(
                    namedArgs: {
                      'floor': '${profile.defaultFloor}',
                      'office': '${profile.defaultOffice}',
                    },
                  ),
                  style: AppTextStyle.getRegularStyle(
                    fontSize: AppFontSize.size_12,
                    color: AppColors.secondPrimery,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
