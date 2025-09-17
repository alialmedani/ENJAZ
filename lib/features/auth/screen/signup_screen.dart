import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/app_padding/app_padding.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';
import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
import 'package:enjaz/features/auth/cubit/auth_cubit.dart' show AuthCubit;
  import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'finish_to_register.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscure1 = true;
  bool _obscure2 = true;
  int? _floor; // 1..5
  int? _office; // 1..6

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  InputDecoration _deco(String hint, {IconData? prefix, Widget? suffix}) {
    final enabled = AppColors.secondPrimery.withOpacity(.30);
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
        borderSide: BorderSide(
          color: AppColors.xprimaryColor,
          width: 1.4,
        ),
      ),
    );
  }

  // void _fillCubit(AuthCubit c) {
  //   c.setRegisterUsername(_usernameCtrl.text.trim());
  //   c.setRegisterPhone(_phoneCtrl.text.trim());
  //   c.setRegisterPassword(_passCtrl.text);
  //   c.setRegisterFloor(_floor ?? 1);
  //   c.setRegisterOffice(_office ?? 1);
  // }

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
                    color: AppColors.black.withOpacity(.05),
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
                      Icons.person_add_alt_1,
                      size: AppFontSize.size_64,
                      color: AppColors.xprimaryColor,
                    ),
                    const SizedBox(height: AppPaddingSize.padding_16),

                    Text(
                      'Create Account',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.getBoldStyle(
                        fontSize: AppFontSize.size_20,
                        color: AppColors.black23,
                      ),
                    ),
                    const SizedBox(height: AppPaddingSize.padding_24),

                    TextFormField(
                      controller: _usernameCtrl,
                      textInputAction: TextInputAction.next,
                      decoration: _deco(
                        'Username',
                        prefix: Icons.person_outline,
                      ),
                      validator: (v) => (v == null || v.trim().length < 3)
                          ? 'أدخل اسم مستخدم (3 أحرف على الأقل)'
                          : null,
                    ),
                    const SizedBox(height: AppPaddingSize.padding_12),

                    TextFormField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      decoration: _deco(
                        'Phone Number',
                        prefix: Icons.phone_iphone,
                      ),
                      validator: (v) {
                        final x = v?.trim() ?? '';
                        if (x.isEmpty) return 'أدخل رقم الهاتف';
                        if (!RegExp(r'^[0-9]{8,14}$').hasMatch(x))
                          return 'رقم غير صالح';
                        return null;
                      },
                    ),
                    const SizedBox(height: AppPaddingSize.padding_12),

                    TextFormField(
                      controller: _passCtrl,
                      obscureText: _obscure1,
                      textInputAction: TextInputAction.next,
                      decoration: _deco(
                        'Password',
                        prefix: Icons.lock_outline,
                        suffix: IconButton(
                          icon: Icon(
                            _obscure1 ? Icons.visibility_off : Icons.visibility,
                            color: AppColors.secondPrimery,
                          ),
                          onPressed: () =>
                              setState(() => _obscure1 = !_obscure1),
                        ),
                      ),
                      validator: (v) => (v == null || v.length < 6)
                          ? 'كلمة المرور لا تقل عن 6'
                          : null,
                    ),
                    const SizedBox(height: AppPaddingSize.padding_12),

                    TextFormField(
                      controller: _confirmCtrl,
                      obscureText: _obscure2,
                      decoration: _deco(
                        'Confirm Password',
                        prefix: Icons.lock_outline,
                        suffix: IconButton(
                          icon: Icon(
                            _obscure2 ? Icons.visibility_off : Icons.visibility,
                            color: AppColors.secondPrimery,
                          ),
                          onPressed: () =>
                              setState(() => _obscure2 = !_obscure2),
                        ),
                      ),
                      validator: (v) => (v != _passCtrl.text)
                          ? 'عدم تطابق كلمة المرور'
                          : null,
                    ),
                    const SizedBox(height: AppPaddingSize.padding_12),

                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _floor,
                            items: List.generate(5, (i) => i + 1)
                                .map(
                                  (f) => DropdownMenuItem(
                                    value: f,
                                    child: Text('Floor $f'),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) => setState(() => _floor = v),
                            decoration: _deco(
                              'Floor (1-5)',
                              prefix: Icons.layers_outlined,
                            ),
                            validator: (v) =>
                                (v == null) ? 'اختر الطابق' : null,
                            iconEnabledColor: AppColors.xprimaryColor,
                          ),
                        ),
                        const SizedBox(width: AppPaddingSize.padding_12),
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _office,
                            items: List.generate(6, (i) => i + 1)
                                .map(
                                  (o) => DropdownMenuItem(
                                    value: o,
                                    child: Text('Office $o'),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) => setState(() => _office = v),
                            decoration: _deco(
                              'Office (1-6)',
                              prefix: Icons.meeting_room_outlined,
                            ),
                            validator: (v) =>
                                (v == null) ? 'اختر المكتب' : null,
                            iconEnabledColor: AppColors.xprimaryColor,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppPaddingSize.padding_20),

                    SizedBox(
                      width: double.infinity,
                      height: AppPaddingSize.padding_52,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!(_formKey.currentState?.validate() ?? false))
                            return;
                          final c = context.read<AuthCubit>();
                          // _fillCubit(c);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const FinishToRegister(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.xprimaryColor,
                          disabledBackgroundColor: AppColors.secondPrimery
                              .withOpacity(.6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppPaddingSize.padding_12,
                            ),
                          ),
                        ),
                        child: Text(
                          'Create Account',
                          style: AppTextStyle.getBoldStyle(
                            fontSize: AppFontSize.size_16,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppPaddingSize.padding_12),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'لديك حساب؟ تسجيل الدخول',
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
