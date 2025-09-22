import 'package:enjaz/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:enjaz/core/classes/cashe_helper.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/app_padding/app_padding.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';
import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
import 'package:enjaz/core/utils/Navigation/navigation.dart';
import 'package:enjaz/features/auth/cubit/auth_cubit.dart';
import 'package:enjaz/features/auth/data/model/login_model.dart';
import 'package:enjaz/features/auth/screen/signup_screen.dart';
import 'package:enjaz/features/root/screen/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtl = TextEditingController();
  final _passCtl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _phoneCtl.dispose();
    _passCtl.dispose();
    super.dispose();
  }

  InputDecoration _deco(String hint, {IconData? prefix, Widget? suffix}) {
    final enabled = AppColors.secondPrimery.withValues(alpha: .30);
    return InputDecoration(
      hintText: hint,
      prefixIcon: prefix == null
          ? null
          : Icon(prefix, color: AppColors.secondPrimery),
      hintStyle: AppTextStyle.getRegularStyle(
        fontSize: AppFontSize.size_14,
        color: AppColors.secondPrimery,
      ),
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppPaddingSize.padding_16,
        vertical: AppPaddingSize.padding_16,
      ),
      suffixIcon: suffix,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppPaddingSize.padding_12),
        borderSide: BorderSide(color: enabled),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppPaddingSize.padding_12),
        borderSide: BorderSide(color: AppColors.xprimaryColor, width: 1.4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.xbackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPaddingSize.padding_20,
              vertical: AppPaddingSize.padding_20,
            ),
            child: Container(
              padding: const EdgeInsets.all(AppPaddingSize.padding_20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppPaddingSize.padding_16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: .05),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Icon(
                      Icons.coffee,
                      size: AppFontSize.size_64,
                      color: AppColors.xprimaryColor,
                    ),
                    const SizedBox(height: AppPaddingSize.padding_16),

                    Text(
                      'login_hello_again'.tr(),
                      textAlign: TextAlign.center,
                      style: AppTextStyle.getBoldStyle(
                        fontSize: AppFontSize.size_22,
                        color: AppColors.black23,
                      ),
                    ),
                    const SizedBox(height: AppPaddingSize.padding_8),
                    Text(
                      'login_welcome_back'.tr(),
                      textAlign: TextAlign.center,
                      style: AppTextStyle.getRegularStyle(
                        fontSize: AppFontSize.size_14,
                        color: AppColors.secondPrimery,
                      ),
                    ),
                    const SizedBox(height: AppPaddingSize.padding_24),

                    TextFormField(
                      controller: _phoneCtl,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[A-Za-z0-9]'),
                        ),
                        LengthLimitingTextInputFormatter(30),
                      ],
                      decoration: _deco(
                        'login_phone_or_username'.tr(),
                        prefix: Icons.person_outline,
                      ),
                      onChanged: (_) =>
                          context.read<AuthCubit>().loginParams.username =
                              _phoneCtl.text.trim(),
                      validator: (v) {
                        final value = v?.trim() ?? '';
                        if (value.isEmpty)
                          return 'err_enter_username_or_phone'.tr();
                        if (!RegExp(r'^[A-Za-z0-9]+$').hasMatch(value)) {
                          return 'err_alnum_only'.tr();
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppPaddingSize.padding_12),

                    TextFormField(
                      controller: _passCtl,
                      obscureText: _obscure,
                      decoration: _deco(
                        'login_password'.tr(),
                        prefix: Icons.lock_outline,
                        suffix: IconButton(
                          icon: Icon(
                            _obscure ? Icons.visibility_off : Icons.visibility,
                            color: AppColors.secondPrimery,
                          ),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                      onChanged: (_) =>
                          context.read<AuthCubit>().loginParams.password =
                              _passCtl.text.trim(),
                      validator: (v) {
                        final value = v?.trim() ?? '';
                        if (value.isEmpty) return 'err_enter_password'.tr();
                        if (value.length < 6) {
                          return 'err_password_min_length'.tr(
                            namedArgs: {'min': '6'},
                          );
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppPaddingSize.padding_16),

                    SizedBox(
                      width: double.infinity,
                      height: AppPaddingSize.padding_52,
                      child: CreateModel<LoginModel>(
                        useCaseCallBack: (model) {
                          if (_formKey.currentState?.validate() != true) {
                            return Future.error('validation_failed');
                          }
                          return context.read<AuthCubit>().login();
                        },
                        withValidation: false,
                        onTap: () {},
                        onSuccess: (LoginModel res) {
                          CacheHelper.setToken(res.accessToken);
                          CacheHelper.setRefreshToken(res.refreshToken);
                          CacheHelper.setExpiresIn(res.expiresIn);
                          CacheHelper.setDateWithExpiry(res.expiresIn ?? 3600);
                          Navigation.pushAndRemoveUntil(const RootScreen());
                        },
                        child: ElevatedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.xprimaryColor,
                            disabledBackgroundColor: AppColors.xprimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppPaddingSize.padding_12,
                              ),
                            ),
                          ),
                          child: Text(
                            'login_sign_in'.tr(),
                            style: AppTextStyle.getBoldStyle(
                              fontSize: AppFontSize.size_16,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppPaddingSize.padding_12),

                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SignupScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'login_no_account_create'.tr(),
                        textAlign: TextAlign.center,
                        style: AppTextStyle.getSemiBoldStyle(
                          fontSize: AppFontSize.size_14,
                          color: AppColors.xprimaryColor,
                        ),
                      ),
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
