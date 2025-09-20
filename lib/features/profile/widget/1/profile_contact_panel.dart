// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:enjaz/core/constant/app_colors/app_colors.dart';
// import 'package:enjaz/core/constant/app_padding/app_padding.dart';
// import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
// import 'package:enjaz/core/constant/text_styles/font_size.dart';
// import 'package:enjaz/features/profile/data/model/user_model.dart';

// /// لوحة احترافية لعرض: Email, Phone Number, Surname
// /// - نفس الستايل الحديث (Gradient + Glass + Copy)
// /// - تخفي الحقول الفارغة تلقائياً
// class ProfileContactPanelPro extends StatelessWidget {
//   final UserModel user;
//   final bool compact;
//   const ProfileContactPanelPro({
//     super.key,
//     required this.user,
//     this.compact = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final email = (user.email ?? '').trim();
//     final phone = (user.phoneNumber ?? '').trim();
//     final surname = (user.surname ?? '').trim();

//     final tiles = <Widget>[
//       if (email.isNotEmpty)
//         _MetaTile(
//           label: 'Email',
//           value: email,
//           icon: Icons.alternate_email,
//           accent: AppColors.darkAccentColor,
//         ),
//       if (phone.isNotEmpty)
//         _MetaTile(
//           label: 'Phone Number',
//           value: phone,
//           icon: Icons.phone_outlined,
//           accent: Colors.green.shade700,
//         ),
//       if (surname.isNotEmpty)
//         _MetaTile(
//           label: 'Surname',
//           value: surname,
//           icon: Icons.badge_outlined,
//           accent: AppColors.xorangeColor,
//         ),
//     ];

//     if (tiles.isEmpty) return const SizedBox.shrink();

//     return ClipRRect(
//       borderRadius: BorderRadius.circular(AppPaddingSize.padding_16),
//       child: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   AppColors.darkAccentColor.withValues(alpha: 08),
//                   AppColors.xorangeColor.withValues(alpha: 08),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//           ),
//           BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
//             child: Container(
//               padding: const EdgeInsets.all(AppPaddingSize.padding_16),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(.62),
//                 borderRadius: BorderRadius.circular(AppPaddingSize.padding_16),
//                 border: Border.all(color: Colors.white.withOpacity(.55)),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(.06),
//                     blurRadius: 14,
//                     offset: const Offset(0, 8),
//                   ),
//                 ],
//               ),
//               child:
//                Column(
//                 children: [
//                   Container(
//                     height: 4,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(2),
//                       gradient: LinearGradient(
//                         colors: [
//                           AppColors.darkAccentColor,
//                           AppColors.xorangeColor,
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: compact ? 8 : 12),
//                   Center(
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,

//                        children: [
//                         Icon(
//                           Icons.contact_mail_outlined,
//                           color: AppColors.secondPrimery,
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           'Contact info',
//                           style: AppTextStyle.getBoldStyle(
//                             fontSize: AppFontSize.size_14,
//                             color: AppColors.black23,
//                           ),
//                         ),
//                         const Spacer(),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: compact ? 10 : 14),
//                   LayoutBuilder(
//                     builder: (context, c) {
//                       final isWide = c.maxWidth >= 520;
//                       return GridView.builder(
//                         physics: const NeverScrollableScrollPhysics(),
//                         shrinkWrap: true,
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: isWide ? 3 : 1,
//                           crossAxisSpacing: 12,
//                           mainAxisSpacing: 12,
//                           childAspectRatio: isWide ? 3.8 : 4.2,
//                         ),
//                         itemCount: tiles.length,
//                         itemBuilder: (_, i) => tiles[i],
//                       );
//                     },
//                   ),
//                 ],
//               ),
         
         
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _MetaTile extends StatelessWidget {
//   final String label;
//   final String value;
//   final IconData icon;
//   final Color accent;
//   const _MetaTile({
//     required this.label,
//     required this.value,
//     required this.icon,
//     required this.accent,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(12),
//       onLongPress: () async {
//         await Clipboard.setData(ClipboardData(text: value));
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Copied $label'),
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       },
//       child: Container(
//         padding: const EdgeInsets.all(AppPaddingSize.padding_12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: AppColors.greyE5),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 36,
//               height: 36,
//               decoration: BoxDecoration(
//                 color: accent.withOpacity(.12),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(icon, color: accent),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     label,
//                     style: AppTextStyle.getRegularStyle(
//                       fontSize: AppFontSize.size_11,
//                       color: AppColors.secondPrimery,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     value,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: AppTextStyle.getBoldStyle(
//                       fontSize: AppFontSize.size_13,
//                       color: AppColors.black23,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
