import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/app_padding/app_padding.dart';
import 'package:enjaz/core/constant/enum/enum.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';
import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
import 'package:enjaz/core/boilerplate/pagination/models/get_list_request.dart';
import 'package:enjaz/core/boilerplate/pagination/widgets/pagination_list.dart';
import 'package:enjaz/features/FO/cubit/place_cubit.dart';
import 'package:enjaz/features/FO/data/model/place_model.dart';
import 'package:enjaz/features/FO/data/usecase/get_place_usecase.dart';
import 'package:enjaz/features/FO/widget/place_dropdown.dart'; // (Floor - type=1)
import 'package:enjaz/features/auth/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'finish_to_register.dart';

/// -----------------------------
/// Helpers
/// -----------------------------
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

DropdownMenuItem<T> _menuItem<T>({
  required T value,
  required String title,
  IconData? icon,
}) {
  return DropdownMenuItem<T>(
    value: value,
    child: Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: AppColors.secondPrimery),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Text(
            title,
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

/// -----------------------------
/// OfficeDropdown (API فقط، بدون copyWith)
/// -----------------------------
/// - مخفي/معطَّل حتى يتم اختيار الطابق.
/// - عند الجلب: نمرر type=2 وfloorId عبر GetPlaceParam (لا نلمس GetListRequest).
/// - نُسند GetPlaceParam الجديد إلى placeCubit.getPlaceParam قبل الاستدعاء.
/// - نُؤجل بلاغ الأب بالـ onChanged(null) بعد الإطار الحالي لتجنب setState أثناء البناء.
class OfficeDropdown extends StatefulWidget {
  const OfficeDropdown({
    super.key,
    required this.floorId,
    required this.selectedOfficeId,
    required this.onChanged,
    this.hideWhenNoFloor = true,
    this.decoration,
  });

  final String floorId;
  final String? selectedOfficeId;
  final ValueChanged<PlaceModel?> onChanged;
  final bool hideWhenNoFloor;
  final InputDecoration? decoration;

  @override
  State<OfficeDropdown> createState() => _OfficeDropdownState();
}

class _OfficeDropdownState extends State<OfficeDropdown> {
  String? _selectedId;

  void _safeSetState(VoidCallback fn) {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(fn);
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selectedOfficeId;
  }

  @override
  void didUpdateWidget(covariant OfficeDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.floorId != widget.floorId) {
      _selectedId = null;
      // ✅ لا تستدعِ onChanged مباشرة أثناء البناء
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        widget.onChanged(null);
        _safeSetState(() {}); // لإعادة بناء الدروب داون بعد التغيير
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final noFloor = widget.floorId.isEmpty;

    if (noFloor && widget.hideWhenNoFloor) {
      // إخفاء كامل حتى يُختار الطابق
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      ignoring: noFloor,
      child: Opacity(
        opacity: noFloor ? .55 : 1,
        child: SizedBox(
          height: 100,
          child: PaginationList(
            // إعادة التحميل عند تغيير الطابق
            key: ValueKey<String>('office-${widget.floorId}'),
            repositoryCallBack: (data) {
              final placeCubit = context.read<PlaceCubit>();
              final req = (data is GetListRequest) ? data : GetListRequest();

              // تعيين بارامترات الجلب (type=2 + floorId)
              placeCubit.getPlaceParam = GetPlaceParam(
                request: req,
                type: 2, // مكاتب
                floorId: widget.floorId, // فلترة حسب الطابق
                term: null,
              );

              return placeCubit.fetchPLaceServies(req);
            },
            listBuilder: (list) {
              final offices = list.cast<PlaceModel>();
              final hasSelected = offices.any(
                (o) => (o.id?.toString() ?? '') == _selectedId,
              );
              final value = hasSelected ? _selectedId : null;

              return DropdownButtonFormField<String>(
                isExpanded: true,
                initialValue: value,
                items: offices
                    .map(
                      (o) => _menuItem<String>(
                        value: (o.id?.toString() ?? ''),
                        title: (o.name ?? '—'),
                        icon: Icons.apartment_outlined,
                      ),
                    )
                    .toList(),
                onChanged: (id) {
                  setState(() => _selectedId = id);
                  final model = offices.firstWhere(
                    (o) => (o.id?.toString() ?? '') == id,
                    orElse: () => PlaceModel(),
                  );
                  widget.onChanged(id == null ? null : model);
                },
                decoration:
                    widget.decoration ??
                    _deco('office'.tr(), prefix: Icons.apartment_outlined),
                iconEnabledColor: AppColors.xprimaryColor,
                validator: (_) {
                  if (widget.floorId.isEmpty) {
                    return null; // لا نُلزم بالمكتب قبل اختيار الطابق
                  }
                  return (value == null || value.isEmpty)
                      ? 'err_select_office'.tr()
                      : null;
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

/// -----------------------------
/// شاشة التسجيل (تستخدم OfficeDropdown الجديد)
/// -----------------------------
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _userCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _passCtrl;
  late final TextEditingController _confirmCtrl;

  bool _obscurePass = true;
  bool _obscureConfirm = true;

  void _safeSetState(VoidCallback fn) {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(fn);
    });
  }

  @override
  void initState() {
    super.initState();
    final p = context.read<AuthCubit>().registerParams;
    _userCtrl = TextEditingController(text: p.userName);
    _phoneCtrl = TextEditingController(text: p.phoneNumber);
    _passCtrl = TextEditingController(text: p.password);
    _confirmCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _userCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          msg,
          style: AppTextStyle.getSemiBoldStyle(
            fontSize: AppFontSize.size_14,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    final params = cubit.registerParams;

    final RoleType? currentRole = RoleType.fromString(
      params.roles.isNotEmpty ? params.roles.first : null,
    );

    return Scaffold(
      backgroundColor: AppColors.xbackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, cons) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppPaddingSize.padding_20,
                vertical: AppPaddingSize.padding_20,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: cons.maxHeight),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Container(
                      padding: const EdgeInsets.all(AppPaddingSize.padding_16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(
                          AppPaddingSize.padding_12,
                        ),
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.person_add_alt_1,
                              size: AppFontSize.size_64,
                              color: AppColors.xprimaryColor,
                            ),
                            const SizedBox(height: AppPaddingSize.padding_16),
                            Text(
                              'signup_title'.tr(),
                              style: AppTextStyle.getBoldStyle(
                                fontSize: AppFontSize.size_20,
                                color: AppColors.black23,
                              ),
                            ),
                            const SizedBox(height: AppPaddingSize.padding_24),

                            // Username
                            TextFormField(
                              controller: _userCtrl,
                              textInputAction: TextInputAction.next,
                              decoration: _deco(
                                'signup_username'.tr(),
                                prefix: Icons.person_outline,
                              ),
                              onChanged: (v) {
                                params.userName = v;
                                params.name = v;
                              },
                              validator: (v) =>
                                  (v == null || v.trim().length < 3)
                                  ? 'err_username_min'.tr(
                                      namedArgs: {'min': '3'},
                                    )
                                  : null,
                            ),
                            const SizedBox(height: AppPaddingSize.padding_12),

                            // Phone
                            TextFormField(
                              controller: _phoneCtrl,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              decoration: _deco(
                                'signup_phone'.tr(),
                                prefix: Icons.phone_iphone,
                              ),
                              onChanged: (v) => params.phoneNumber = v,
                              validator: (v) {
                                final x = v?.trim() ?? '';
                                if (x.isEmpty) return 'err_phone_required'.tr();
                                if (!RegExp(r'^[0-9]{8,14}$').hasMatch(x)) {
                                  return 'err_phone_invalid'.tr();
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppPaddingSize.padding_12),

                            // Password
                            TextFormField(
                              controller: _passCtrl,
                              obscureText: _obscurePass,
                              textInputAction: TextInputAction.next,
                              decoration: _deco(
                                'signup_password'.tr(),
                                prefix: Icons.lock_outline,
                                suffix: IconButton(
                                  icon: Icon(
                                    _obscurePass
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: AppColors.secondPrimery,
                                  ),
                                  onPressed: () => setState(
                                    () => _obscurePass = !_obscurePass,
                                  ),
                                ),
                              ),
                              onChanged: (v) => params.password = v,
                              validator: (v) => (v == null || v.length < 6)
                                  ? 'err_password_min'.tr(
                                      namedArgs: {'min': '6'},
                                    )
                                  : null,
                            ),
                            const SizedBox(height: AppPaddingSize.padding_12),

                            // Confirm
                            TextFormField(
                              controller: _confirmCtrl,
                              obscureText: _obscureConfirm,
                              decoration: _deco(
                                'signup_confirm_password'.tr(),
                                prefix: Icons.lock_outline,
                                suffix: IconButton(
                                  icon: Icon(
                                    _obscureConfirm
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: AppColors.secondPrimery,
                                  ),
                                  onPressed: () => setState(
                                    () => _obscureConfirm = !_obscureConfirm,
                                  ),
                                ),
                              ),
                              validator: (v) => (v != _passCtrl.text)
                                  ? 'err_password_mismatch'.tr()
                                  : null,
                            ),
                            const SizedBox(height: AppPaddingSize.padding_12),

                            // Floor + Role
                            Row(
                              children: [
                                // Floor (type=1)
                                Expanded(
                                  child: PlaceDropdown(
                                    initialPlaceId: params.floorId.isEmpty
                                        ? null
                                        : params.floorId,
                                    decoration: _deco(
                                      // لديك مفتاح "floor" جاهز في ملفّك
                                      'floor'.tr(),
                                      prefix: Icons.layers_outlined,
                                    ),
                                    onChanged: (place) {
                                      params.floorId = place?.id ?? '';
                                      _safeSetState(() {});
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: AppPaddingSize.padding_12,
                                ),

                                // Role
                                Expanded(
                                  child: DropdownButtonFormField<RoleType>(
                                    isExpanded: true,
                                    initialValue: currentRole,
                                    items: RoleType.values
                                        .map(
                                          (rt) => DropdownMenuItem<RoleType>(
                                            value: rt,
                                            child: Text(
                                              rt.displayString(), // نفترض displayString() مترجم داخليًا لديك
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
                                      params.roles = (rt == null)
                                          ? []
                                          : [rt.toApiString()];
                                      _safeSetState(() {});
                                    },
                                    decoration: _deco(
                                      'signup_role'.tr(),
                                      prefix: Icons.badge_outlined,
                                    ),
                                    iconEnabledColor: AppColors.xprimaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppPaddingSize.padding_12),

                            // Office (type=2) — يعتمد على floorId
                            OfficeDropdown(
                              floorId: params.floorId,
                              selectedOfficeId: params.officeId.isEmpty
                                  ? null
                                  : params.officeId,
                              onChanged: (place) {
                                // ⚠️ لا تستخدم setState مباشرة من كول باك طفل أثناء البناء
                                params.officeId = (place?.id?.toString() ?? '');
                                _safeSetState(() {});
                              },
                              hideWhenNoFloor:
                                  true, // اجعلها false لعرضه معطَّلاً بدل إخفائه
                              decoration: _deco(
                                'office'.tr(),
                                prefix: Icons.apartment_outlined,
                              ),
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
                                    'signup_hint_edit_later'.tr(),
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
                                'signup_have_account_login'.tr(),
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
      bottomNavigationBar: _bottomBar(
        onSubmit: () {
          final valid = _formKey.currentState?.validate() ?? false;
          if (!valid) return;
          final p = context.read<AuthCubit>().registerParams;
          if (p.floorId.isEmpty) {
            return _showError('err_select_floor'.tr());
          }
          if (p.officeId.isEmpty) {
            return _showError('err_select_office'.tr());
          }
          if ((p.name).trim().isEmpty) p.name = p.userName;
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const FinishToRegister()));
        },
      ),
    );
  }

  Widget _bottomBar({required VoidCallback onSubmit}) {
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
            const Spacer(),
            SizedBox(
              height: AppPaddingSize.padding_48,
              child: ElevatedButton(
                onPressed: onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.xprimaryColor,
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
                  'signup_create_account'.tr(),
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
}
