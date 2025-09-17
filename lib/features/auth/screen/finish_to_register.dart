import 'package:enjaz/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/app_padding/app_padding.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';
import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
import 'package:enjaz/core/utils/Navigation/navigation.dart';
import 'package:enjaz/features/auth/cubit/auth_cubit.dart';
  import 'package:enjaz/features/auth/data/model/register_model.dart';
import 'package:enjaz/features/root/screen/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FinishToRegister extends StatelessWidget {
  const FinishToRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.xbackgroundColor,
      appBar: AppBar(
        title: Text(
          'إنهاء التسجيل',
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
          // useCaseCallBack: () => context.read<AuthCubit>().sigup(),

          // لازم modelBuilder لأن GetModel يلفّه بـ RefreshIndicator
          modelBuilder: (_) => const SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: SizedBox.shrink(),
          ),

          onSuccess: (_) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigation.pushAndRemoveUntil(const RootScreen());
            });
          },

          loading: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppColors.xprimaryColor),
                const SizedBox(height: AppPaddingSize.padding_12),
                Text(
                  'جاري إنشاء الحساب...',
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
                : 'حدث خطأ غير متوقع';
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
