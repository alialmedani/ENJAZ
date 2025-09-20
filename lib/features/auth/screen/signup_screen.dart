import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/app_padding/app_padding.dart';
import 'package:enjaz/core/constant/enum/enum.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';
import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
import 'package:enjaz/features/FO/widget/place_dropdown.dart';
import 'package:enjaz/features/auth/cubit/auth_cubit.dart' show AuthCubit;
import 'package:enjaz/features/auth/data/model/register_model.dart';
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

  // نحتاج الكنترولرين فقط للمقارنة بين كلمتي المرور
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscure1 = true;
  bool _obscure2 = true;

  bool _acceptedRules = false; // تبقى محلية لأنها ليست جزءًا من الـ params

  // أدوار للعرض في الـ UI
  static const _uiRoles = <String>[
    'User',
    'Office Boy',
    'Employee',
    'Manager',
    'Admin',
  ];

  // مكاتب وهمية للعرض (بدّلها ببيانات الـ API لاحقًا)
  static const _offices = <Map<String, String>>[
    {'id': '1', 'name': 'Main Office'},
    {'id': '2', 'name': 'Branch - West'},
    {'id': '3', 'name': 'Branch - East'},
  ];

  // تحويل اسم الدور الظاهر في الواجهة إلى القيمة المطلوبة من الـ API
  String _uiToApiRole(String? uiRole) {
    if (uiRole == null) return '';
    switch (uiRole) {
      case 'User':
        return 'User';
      case 'Office Boy':
        return 'OfficeBoy';
      default:
        return uiRole;
    }
  }

  // عكس التحويل: من قيمة الـ API إلى ما يُعرض في الواجهة (لإظهار القيمة المختارة حاليًا)
  String? _apiToUiRole(List<RegisterModel> roles) {
    if (roles.isEmpty ||
        roles.first.roles == null ||
        roles.first.roles!.isEmpty)
      return null;
    final api = roles.first.roles!.first;
    switch (api) {
      case 'User':
        return 'User';
      case 'OfficeBoy':
        return 'Office Boy';
      default:
        return api;
    }
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

  Widget _card(Widget child) {
    return Container(
      padding: const EdgeInsets.all(AppPaddingSize.padding_16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppPaddingSize.padding_12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: .05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  DropdownMenuItem<T> _menuItem<T>({
    required T value,
    required String title,
    IconData? icon,
  }) {
    return DropdownMenuItem<T>(
      value: value,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: AppColors.secondPrimery),
            const SizedBox(width: 8),
          ],
          Flexible(
            fit: FlexFit.loose,
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.getRegularStyle(
                fontSize: AppFontSize.size_14,
                color: AppColors.black23,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomActionBar(VoidCallback onSubmit) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPaddingSize.padding_16,
          vertical: AppPaddingSize.padding_12,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border(
            top: BorderSide(
              color: AppColors.secondPrimery.withValues(alpha: .15),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: .06),
              blurRadius: 16,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _acceptedRules = !_acceptedRules),
                borderRadius: BorderRadius.circular(AppPaddingSize.padding_12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: _acceptedRules,
                      activeColor: AppColors.xprimaryColor,
                      onChanged: (v) =>
                          setState(() => _acceptedRules = v ?? false),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: AppTextStyle.getRegularStyle(
                            fontSize: AppFontSize.size_13,
                            color: AppColors.black23,
                          ),
                          children: [
                            const TextSpan(text: 'أوافق على '),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: GestureDetector(
                                onTap: () {
                                  // Navigator.pushNamed(context, '/terms');
                                },
                                child: Text(
                                  'الشروط والأحكام',
                                  style: AppTextStyle.getSemiBoldStyle(
                                    fontSize: AppFontSize.size_13,
                                    color: AppColors.xprimaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppPaddingSize.padding_12),
            SizedBox(
              height: AppPaddingSize.padding_48,
              child: ElevatedButton(
                onPressed: onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.xprimaryColor,
                  disabledBackgroundColor: AppColors.secondPrimery.withValues(
                    alpha: .6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppPaddingSize.padding_12,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPaddingSize.padding_20,
                  ),
                ),
                child: Text(
                  'Create Account',
                  style: AppTextStyle.getBoldStyle(
                    fontSize: AppFontSize.size_15,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit(AuthCubit cubit) {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    if (!_acceptedRules) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'يجب الموافقة على الشروط أولاً',
            style: AppTextStyle.getSemiBoldStyle(
              fontSize: AppFontSize.size_14,
              color: AppColors.white,
            ),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // تحقق أساسي من الحقول المطلوبة
    final p = cubit.registerParams;
    if ((p.officeId).isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            'الرجاء اختيار المكتب (Office)',
            style: AppTextStyle.getSemiBoldStyle(
              fontSize: AppFontSize.size_14,
              color: AppColors.white,
            ),
          ),
        ),
      );
      return;
    }
    if ((p.floorId).isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            'الرجاء اختيار الطابق (Floor)',
            style: AppTextStyle.getSemiBoldStyle(
              fontSize: AppFontSize.size_14,
              color: AppColors.white,
            ),
          ),
        ),
      );
      return;
    }

    // إن كان name فارغ لأي سبب، اجعله userName
    if ((p.name).trim().isEmpty) {
      p.name = p.userName;
    }

    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const FinishToRegister()));
  }

  @override
  void dispose() {
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    final params = cubit.registerParams;

    // استنتاج القيم الحالية من الـ cubit لربطها بالـ widgets
    final selectedFloorInt = int.tryParse(params.floorId);
    final selectedRoleUi = _apiToUiRole(params.roles); // قد تكون null
    final selectedOfficeId = params.officeId.isEmpty ? null : params.officeId;

    // current role in UI from params
    RoleType? currentRole;
    if (params.roles.isNotEmpty &&
        params.roles.first.roles != null &&
        params.roles.first.roles!.isNotEmpty) {
      currentRole = RoleType.fromString(params.roles.first.roles!.first);
    }
    return Scaffold(
      backgroundColor: AppColors.xbackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppPaddingSize.padding_20,
                vertical: AppPaddingSize.padding_20,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: _card(
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
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

                            // Username
                            TextFormField(
                              initialValue: params.userName,
                              textInputAction: TextInputAction.next,
                              decoration: _deco(
                                'Username',
                                prefix: Icons.person_outline,
                              ),
                              onChanged: (value) {
                                final r = context
                                    .read<AuthCubit>()
                                    .registerParams;
                                r.userName = value;
                                r.name = value; // كما طلبت: name = userName
                                setState(
                                  () {},
                                ); // لتحديث الـ initialValue المشتقة الأخرى إن لزم
                              },
                              validator: (v) =>
                                  (v == null || v.trim().length < 3)
                                  ? 'أدخل اسم مستخدم (3 أحرف على الأقل)'
                                  : null,
                            ),
                            const SizedBox(height: AppPaddingSize.padding_12),

                            // Phone
                            TextFormField(
                              initialValue: params.phoneNumber,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              decoration: _deco(
                                'Phone Number',
                                prefix: Icons.phone_iphone,
                              ),
                              onChanged: (value) =>
                                  context
                                          .read<AuthCubit>()
                                          .registerParams
                                          .phoneNumber =
                                      value,
                              validator: (v) {
                                final x = v?.trim() ?? '';
                                if (x.isEmpty) return 'أدخل رقم الهاتف';
                                if (!RegExp(r'^[0-9]{8,14}$').hasMatch(x)) {
                                  return 'رقم غير صالح';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppPaddingSize.padding_12),

                            // Password
                            TextFormField(
                              controller: _passCtrl,
                              obscureText: _obscure1,
                              textInputAction: TextInputAction.next,
                              decoration: _deco(
                                'Password',
                                prefix: Icons.lock_outline,
                                suffix: IconButton(
                                  icon: Icon(
                                    _obscure1
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: AppColors.secondPrimery,
                                  ),
                                  onPressed: () =>
                                      setState(() => _obscure1 = !_obscure1),
                                ),
                              ),
                              onChanged: (value) =>
                                  context
                                          .read<AuthCubit>()
                                          .registerParams
                                          .password =
                                      value,
                              validator: (v) => (v == null || v.length < 6)
                                  ? 'كلمة المرور لا تقل عن 6'
                                  : null,
                            ),
                            const SizedBox(height: AppPaddingSize.padding_12),

                            // Confirm Password
                            TextFormField(
                              controller: _confirmCtrl,
                              obscureText: _obscure2,
                              decoration: _deco(
                                'Confirm Password',
                                prefix: Icons.lock_outline,
                                suffix: IconButton(
                                  icon: Icon(
                                    _obscure2
                                        ? Icons.visibility_off
                                        : Icons.visibility,
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

                            // Row: Floor + Role
                            Row(
                              children: [
                                // Floor
                                Expanded(child: PlaceDropdown()),
                                const SizedBox(
                                  width: AppPaddingSize.padding_12,
                                ),

                                // Role
                                Expanded(
                                  child: DropdownButtonFormField<RoleType>(
                                    isExpanded: true,
                                    value: currentRole,
                                    items: RoleType.values
                                        .map(
                                          (rt) => DropdownMenuItem<RoleType>(
                                            value: rt,
                                            child: Text(
                                              rt.displayString(),
                                              style:
                                                  AppTextStyle.getRegularStyle(
                                                    fontSize:
                                                        AppFontSize.size_14,
                                                    color: AppColors.black23,
                                                  ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (rt) {
                                      final api = rt?.toApiString();
                                      final p = context
                                          .read<AuthCubit>()
                                          .registerParams;
                                      p.roles = (api == null || api.isEmpty)
                                          ? []
                                          : [
                                              RegisterModel(roles: [api]),
                                            ];
                                      setState(() {});
                                    },
                                    decoration: _deco(
                                      'Role',
                                      prefix: Icons.badge_outlined,
                                    ),
                                    validator: (_) {
                                      final roles = context
                                          .read<AuthCubit>()
                                          .registerParams
                                          .roles;
                                      final ok =
                                          roles.isNotEmpty &&
                                          roles.first.roles != null &&
                                          roles.first.roles!.isNotEmpty;
                                      return ok ? null : 'اختر الدور';
                                    },
                                    iconEnabledColor: AppColors.xprimaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppPaddingSize.padding_12),

                            // Office
                            DropdownButtonFormField<String>(
                              isExpanded: true, // ✅

                              value: selectedOfficeId,
                              items: _offices
                                  .map(
                                    (o) => _menuItem<String>(
                                      value: o['id']!,
                                      title: o['name']!,
                                      icon: Icons.apartment_outlined,
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                context
                                        .read<AuthCubit>()
                                        .registerParams
                                        .officeId =
                                    value ?? '';
                                setState(() {});
                              },
                              decoration: _deco(
                                'Office',
                                prefix: Icons.apartment_outlined,
                              ),
                              validator: (v) {
                                final id = context
                                    .read<AuthCubit>()
                                    .registerParams
                                    .officeId;
                                return (id.isEmpty) ? 'اختر المكتب' : null;
                              },
                              iconEnabledColor: AppColors.xprimaryColor,
                            ),

                            const SizedBox(height: AppPaddingSize.padding_8),

                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color: AppColors.secondPrimery,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'يمكنك تعديل المكتب/الطابق لاحقًا من الإعدادات إن كانت الصلاحيات تسمح.',
                                    style: AppTextStyle.getRegularStyle(
                                      fontSize: AppFontSize.size_12,
                                      color: AppColors.secondPrimery,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: AppPaddingSize.padding_8),

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
          },
        ),
      ),

      bottomNavigationBar: _bottomActionBar(() => _handleSubmit(cubit)),
    );
  }
}

// --------- ملاحظة حول RegisterModel/Params ---------
// تم حذف أي state محلي للطابق/الدور/المكتب.
// كل الحقول تُكتب مباشرة في context.read<AuthCubit>().registerParams عبر onChanged.
// الدور يُحوَّل بالقيم:
//   "User" → "User", "Office Boy" → "OfficeBoy"
// وتُخزَّن داخل List<RegisterModel> كما يقتضيه موديلك.
