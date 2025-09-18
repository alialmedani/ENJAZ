import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/app_padding/app_padding.dart';
import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';

import 'package:enjaz/features/profile/cubit/profile_cubit.dart';
import 'package:enjaz/features/profile/data/model/user_profile.dart';

class SettingsCard extends StatefulWidget {
  final UserProfile profile;
  const SettingsCard({super.key, required this.profile});

  @override
  State<SettingsCard> createState() => _SettingsCardState();
}

class _SettingsCardState extends State<SettingsCard> {
  late AppLanguage _lang;
  late bool _notif;
  late int _floor;
  late int _office;

  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _lang = widget.profile.language;
    _notif = widget.profile.notificationsEnabled;
    _floor = widget.profile.defaultFloor;
    _office = widget.profile.defaultOffice;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    final p = cubit.state ?? widget.profile;

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
          Row(
            children: [
              Text(
                'settings_title'.tr(),
                style: AppTextStyle.getBoldStyle(
                  fontSize: AppFontSize.size_14,
                  color: AppColors.black23,
                ),
              ),
              const Spacer(),
              AnimatedOpacity(
                opacity: _saved ? 1 : 0,
                duration: const Duration(milliseconds: 220),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppColors.darkAccentColor,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'saved'.tr(),
                      style: AppTextStyle.getBoldStyle(
                        fontSize: AppFontSize.size_12,
                        color: AppColors.darkAccentColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppPaddingSize.padding_12),

          DropdownButtonFormField<AppLanguage>(
            decoration: InputDecoration(
              labelText: 'settings_language'.tr(),
              border: const OutlineInputBorder(),
            ),
            value: _lang,
            items: [
              DropdownMenuItem(
                value: AppLanguage.ar,
                child: Text('lang_ar'.tr()),
              ),
              DropdownMenuItem(
                value: AppLanguage.en,
                child: Text('lang_en'.tr()),
              ),
            ],
            onChanged: (v) => setState(() => _lang = v ?? _lang),
          ),
          const SizedBox(height: AppPaddingSize.padding_12),

          SwitchListTile(
            title: Text('settings_notifications'.tr()),
            value: _notif,
            onChanged: (v) => setState(() => _notif = v),
          ),
          const SizedBox(height: AppPaddingSize.padding_12),

          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'default_floor'.tr(),
                    border: const OutlineInputBorder(),
                  ),
                  value: _floor,
                  items: List.generate(5, (i) => i + 1)
                      .map((f) => DropdownMenuItem(value: f, child: Text('$f')))
                      .toList(),
                  onChanged: (v) => setState(() => _floor = v ?? _floor),
                ),
              ),
              const SizedBox(width: AppPaddingSize.padding_12),
              Expanded(
                child: DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'default_office'.tr(),
                    border: const OutlineInputBorder(),
                  ),
                  value: _office,
                  items: List.generate(6, (i) => i + 1)
                      .map((o) => DropdownMenuItem(value: o, child: Text('$o')))
                      .toList(),
                  onChanged: (v) => setState(() => _office = v ?? _office),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppPaddingSize.padding_12),

          // أزرار الحفظ/التصدير مُعطّلة كما في الأصل (معلّقة)
          // فعّلها عند تجهيز الـ usecase
        ],
      ),
    );
  }
}
