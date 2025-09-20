// import 'package:easy_localization/easy_localization.dart';
// import 'package:enjaz/features/profile/screen/widget/fade_slide_in.dart';
// import 'package:enjaz/features/profile/screen/widget/segmented_tabs.dart';
// import 'package:flutter/material.dart';
// import 'package:enjaz/core/constant/app_colors/app_colors.dart';
// import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
// import 'package:enjaz/core/constant/text_styles/font_size.dart';

// class StaffHeader extends StatelessWidget {
//   final String title;
//   final TabController controller;
//   const StaffHeader({super.key, required this.title, required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     const bg = Color(0xFFF6EDE7);
//     return SizedBox(
//       height: 150,
//       width: double.infinity,
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           FadeSlideIn(
//             delay: const Duration(milliseconds: 20),
//             child: Container(
//               height: 120,
//               color: bg,
//               padding: EdgeInsets.only(
//                 top: MediaQuery.of(context).padding.top + 12,
//                 left: 16,
//                 right: 16,
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       title,
//                       style: AppTextStyle.getBoldStyle(
//                         fontSize: AppFontSize.size_18,
//                         color: AppColors.black,
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () {},
//                     icon: const Icon(
//                       Icons.notifications_outlined,
//                       color: AppColors.black,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             left: 16,
//             right: 16,
//             bottom: -18,
//             child: FadeSlideIn(
//               delay: const Duration(milliseconds: 120),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: bg,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(.06),
//                       blurRadius: 12,
//                       offset: const Offset(0, 6),
//                     ),
//                   ],
//                 ),
//                 padding: const EdgeInsets.all(6),
//                 child: SegmentedTabs(
//                   controller: controller,
//                   tabs: [
//                     'tab_queue'.tr(),
//                     'tab_scheduled'.tr(),
//                     'tab_my_orders'.tr(),
//                     'tab_profile'.tr(),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
