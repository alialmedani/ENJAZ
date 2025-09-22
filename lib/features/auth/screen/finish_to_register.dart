import 'package:enjaz/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/app_padding/app_padding.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';
import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
import 'package:enjaz/core/utils/Navigation/navigation.dart';
import 'package:enjaz/features/auth/data/model/register_model.dart';
import 'package:enjaz/features/auth/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../cubit/auth_cubit.dart';

class FinishToRegister extends StatelessWidget {
  const FinishToRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.xbackgroundColor,
      appBar: AppBar(
        title: Text(
          'register_finish_title'.tr(),
          style: AppTextStyle.getBoldStyle(
            fontSize: AppFontSize.size_16,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.xprimaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppPaddingSize.padding_20),
        child: GetModel<RegisterModel>(
          useCaseCallBack: () => context.read<AuthCubit>().register(),
          modelBuilder: (_) => const SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: SizedBox.shrink(),
          ),
          onSuccess: (_) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigation.pushAndRemoveUntil(const LoginScreen());
            });
          },
          loading: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppColors.xprimaryColor),
                const SizedBox(height: AppPaddingSize.padding_12),
                Text(
                  'register_creating_account'.tr(),
                  style: AppTextStyle.getRegularStyle(
                    fontSize: AppFontSize.size_14,
                    color: AppColors.black23,
                  ),
                ),
              ],
            ),
          ),
          onError: (msg) {
            final message = (msg?.toString().isNotEmpty ?? false)
                ? msg.toString()
                : 'err_unexpected'.tr();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: AppColors.secondPrimery,
              ),
            );
          },
        ),
      ),
    );
  }
}
