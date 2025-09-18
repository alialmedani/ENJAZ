// lib/features/profile/widgets/favorites_row.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/app_padding/app_padding.dart';
import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';
import '../../data/model/user_profile.dart';

class FavoritesRow extends StatelessWidget {
  final UserProfile profile;
  const FavoritesRow({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    if (profile.favorites.isEmpty) return const SizedBox.shrink();
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'favourite'.tr(),
            style: AppTextStyle.getBoldStyle(
              fontSize: AppFontSize.size_14,
              color: AppColors.black23,
            ),
          ),
          const SizedBox(height: AppPaddingSize.padding_12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: profile.favorites.map((name) {
                return Padding(
                  padding: const EdgeInsets.only(
                    right: AppPaddingSize.padding_8,
                  ),
                  child: ActionChip(
                    backgroundColor: AppColors.darkAccentColor.withOpacity(.10),
                    avatar: Icon(
                      Icons.bolt,
                      color: AppColors.darkAccentColor,
                      size: 18,
                    ),
                    label: Text(
                      name,
                      style: TextStyle(
                        color: AppColors.darkAccentColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('quick_order_todo'.tr())),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
