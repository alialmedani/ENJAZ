// // lib/features/profile/widgets/settings_card.dart
// import 'package:enjaz/features/profile/data/model/user_model.dart';
// import 'package:flutter/material.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:enjaz/core/constant/app_colors/app_colors.dart';
// import 'package:enjaz/core/constant/app_padding/app_padding.dart';
// import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
// import 'package:enjaz/core/constant/text_styles/font_size.dart';

// class SettingsCard extends StatelessWidget {
//   final UserModel userModel;
//   const SettingsCard({super.key, required this.userModel});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(AppPaddingSize.padding_16),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(AppPaddingSize.padding_12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: .06),
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Text(
//                 'settings_title'.tr(),
//                 style: AppTextStyle.getBoldStyle(
//                   fontSize: AppFontSize.size_14,
//                   color: AppColors.black23,
//                 ),
//               ),
//               const Spacer(),
//               AnimatedOpacity(
//                 opacity: 1,
//                 duration: const Duration(milliseconds: 220),
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.check_circle,
//                       color: AppColors.darkAccentColor,
//                       size: 18,
//                     ),
//                     const SizedBox(width: 6),
//                     Text(
//                       'saved'.tr(),
//                       style: AppTextStyle.getBoldStyle(
//                         fontSize: AppFontSize.size_12,
//                         color: AppColors.darkAccentColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: AppPaddingSize.padding_12),

//           // DropdownButtonFormField<AppLanguage>(
//           //   decoration: InputDecoration(
//           //     labelText: 'settings_language'.tr(),
//           //     border: const OutlineInputBorder(),
//           //   ),
//           //   value: _lang,
//           //   items: [
//           //     DropdownMenuItem(
//           //       value: AppLanguage.ar,
//           //       child: Text('lang_ar'.tr()),
//           //     ),
//           //     DropdownMenuItem(
//           //       value: AppLanguage.en,
//           //       child: Text('lang_en'.tr()),
//           //     ),
//           //   ],
//           //   onChanged: (v) => setState(() => _lang = v ?? _lang),
//           // ),
//           const SizedBox(height: AppPaddingSize.padding_12),

//           SwitchListTile(
//             title: Text('settings_notifications'.tr()),
//             value: true,
//             onChanged: (val) {},
//           ),
//           const SizedBox(height: AppPaddingSize.padding_12),

//           // Row(
//           //   children: [
//           //     // Expanded(
//           //     //   child: DropdownButtonFormField<int>(
//           //     //     decoration: InputDecoration(
//           //     //       labelText: 'default_floor'.tr(),
//           //     //       border: const OutlineInputBorder(),
//           //     //     ),
//           //     //     value: userModel.floor,
//           //     //     items: List.generate(5, (i) => i + 1)
//           //     //         .map((f) => DropdownMenuItem(value: f, child: Text('$f')))
//           //     //         .toList(),
//           //     //     onChanged: (v) => {},
//           //     //   ),
//           //     // ),
//           //     const SizedBox(width: AppPaddingSize.padding_12),
//           //     Expanded(
//           //       child: DropdownButtonFormField<String>(
//           //         decoration: InputDecoration(
//           //           labelText: 'default_office'.tr(),
//           //           border: const OutlineInputBorder(),
//           //         ),
//           //         value: userModel.office,
//           //         items: ['A', 'B', 'C', 'D', 'E']
//           //             .map((o) => DropdownMenuItem(value: o, child: Text(o)))
//           //             .toList(),
//           //         onChanged: (v) => {},
//           //       ),
//           //     ),
//           //   ],
//           // ),
//           const SizedBox(height: AppPaddingSize.padding_12),

//           Align(
//             alignment: Alignment.centerRight,
//             child: ElevatedButton.icon(
//               onPressed: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('settings_save_todo'.tr())),
//                 );
//               },
//               icon: const Icon(Icons.save),
//               label: Text('btn_save'.tr()),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
