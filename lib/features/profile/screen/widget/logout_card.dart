// lib/features/profile/widgets/logout_card.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:enjaz/core/classes/cashe_helper.dart';
import 'package:enjaz/core/constant/end_points/cashe_helper_constant.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/app_padding/app_padding.dart';
import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';
import 'package:enjaz/features/auth/screen/login_screen.dart';

class LogoutCard extends StatelessWidget {
  const LogoutCard({super.key});

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
          const Icon(Icons.logout),
          const SizedBox(width: AppPaddingSize.padding_12),
          Expanded(
            child: Text(
              'sign_out'.tr(),
              style: AppTextStyle.getBoldStyle(
                fontSize: AppFontSize.size_14,
                color: AppColors.black23,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('sign_out_confirm_title'.tr()),
                  content: Text('sign_out_confirm_body'.tr()),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('cancel'.tr()),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('sign_out'.tr()),
                    ),
                  ],
                ),
              );
              if (ok == true && context.mounted) {
                try {
                  await CacheHelper.box.delete(accessToken);
                  await CacheHelper.box.delete(refreshToken);
                  await CacheHelper.box.delete('current_user_phone');
                  await CacheHelper.box.delete('current_user_role');
                } catch (_) {}
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('signed_out'.tr())));
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (r) => false,
                );
              }
            },
            child: Text('sign_out'.tr()),
          ),
        ],
      ),
    );
  }
}
