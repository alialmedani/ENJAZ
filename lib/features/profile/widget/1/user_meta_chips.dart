// import 'package:flutter/material.dart';
// import 'package:enjaz/features/profile/data/model/user_model.dart';
// import 'package:enjaz/core/constant/app_colors/app_colors.dart';
// import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
// import 'package:enjaz/core/constant/text_styles/font_size.dart';

// class UserMetaChips extends StatelessWidget {
//   final UserModel user;
//   final bool showRoles;
//   const UserMetaChips({super.key, required this.user, this.showRoles = true});

//   @override
//   Widget build(BuildContext context) {
//     final chips = <Widget>[];

//     if (user.floor != null) {
//       chips.add(
//         _chip(
//           icon: Icons.stairs_outlined,
//           text: 'Floor ${user.floor}',
//           fg: AppColors.darkAccentColor,
//           bg: AppColors.darkAccentColor.withOpacity(.10),
//         ),
//       );
//     }
//     final office = (user.office ?? '').trim();
//     if (office.isNotEmpty) {
//       chips.add(
//         _chip(
//           icon: Icons.meeting_room_outlined,
//           text: 'Office $office',
//           fg: AppColors.xorangeColor,
//           bg: AppColors.xorangeColor.withOpacity(.12),
//         ),
//       );
//     }
//     if (showRoles && (user.roles ?? const []).isNotEmpty) {
//       for (final r in user.roles!) {
//         chips.add(
//           _chip(
//             icon: Icons.verified_user_outlined,
//             text: r,
//             fg: AppColors.secondPrimery,
//             bg: AppColors.secondPrimery.withOpacity(.10),
//           ),
//         );
//       }
//     }

//     return Wrap(spacing: 8, runSpacing: 8, children: chips);
//   }

//   Widget _chip({
//     required IconData icon,
//     required String text,
//     required Color fg,
//     required Color bg,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(999),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 14, color: fg),
//           const SizedBox(width: 6),
//           Text(
//             text,
//             style: AppTextStyle.getBoldStyle(
//               fontSize: AppFontSize.size_12,
//               color: fg,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
