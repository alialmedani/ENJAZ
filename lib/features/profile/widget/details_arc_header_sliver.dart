// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//  import 'package:enjaz/core/constant/app_colors/app_colors.dart';
// import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
// import 'package:enjaz/core/constant/text_styles/font_size.dart';

// import 'animated_dark_header_bg.dart';
// import 'fade_slide_in.dart';
 
// /// Sliver header بروح ProfileArcHeader لكن بدون Tabs.
// /// يدعم pinned، ويعرض Container سفلي (اختياري) لشرائح الحالة / معلومات سريعة.
// class DetailsArcHeaderSliver extends SliverPersistentHeaderDelegate {
//   final String title;
//   final Widget?
//   bottom; // ويدجت اختيارية تظهر كبطاقة في الأسفل (مثلاً: StatusChip + تاريخ)
//   final double minHeight;
//   final double maxHeight;
//   final VoidCallback? onAction; // زر إجراء يمين (اختياري)
//   final IconData actionIcon;

//   DetailsArcHeaderSliver({
//     required this.title,
//     this.bottom,
//     this.minHeight = 80,
//     this.maxHeight = 168,
//     this.onAction,
//     this.actionIcon = Icons.info_outline,
//   });

//   @override
//   double get minExtent => minHeight;
//   @override
//   double get maxExtent => maxHeight;

//   @override
//   Widget build(
//     BuildContext context,
//     double shrinkOffset,
//     bool overlapsContent,
//   ) {
//     final top = MediaQuery.of(context).padding.top;
//     final t = (shrinkOffset / (maxHeight - minHeight)).clamp(0.0, 1.0);

//     return Stack(
//       clipBehavior: Clip.none,
//       children: [
//         // خلفية متدرجة متحركة
//         Positioned.fill(child: AnimatedDarkHeaderBackground(height: maxHeight)),

//         // طبقة المحتوى (العنوان + أزرار)
//         Positioned.fill(
//           child: Padding(
//             padding: EdgeInsets.only(top: top + 12, left: 16, right: 16),
//             child: Row(
//               children: [
//                 // زر رجوع
//                 FadeScaleIconButton(
//                   icon: Icons.arrow_back_ios_new_rounded,
//                   onTap: () {
//                     HapticFeedback.selectionClick();
//                     Navigator.of(context).maybePop();
//                   },
//                 ),
//                 const SizedBox(width: 8),

//                 // العنوان
//                 Expanded(
//                   child: FadeSlideIn(
//                     delay: const Duration(milliseconds: 40),
//                     child: Text(
//                       title,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: AppTextStyle.getBoldStyle(
//                         fontSize: AppFontSize.size_18,
//                         color: AppColors.darkSubHeadingColor1,
//                       ),
//                     ),
//                   ),
//                 ),

//                 // زر إجراء اختياري (يمين)
//                 if (onAction != null)
//                   FadeScaleIconButton(
//                     icon: actionIcon,
//                     onTap: () {
//                       HapticFeedback.selectionClick();
//                       onAction?.call();
//                     },
//                   ),
//               ],
//             ),
//           ),
//         ),

//         // بطاقة سفلية (اختيارية) — تثبت أسفل الهيدر وتتحرك لفوق عند الانكماش
//         if (bottom != null)
//           Positioned(
//             left: 16,
//             right: 16,
//             // نحرّكها قليلاً حسب الانكماش لتظل لطيفة
//             bottom: -22 + (22 * t),
//             child: FadeSlideIn(
//               delay: const Duration(milliseconds: 120),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: AppColors.xbackgroundColor2,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(.10),
//                       blurRadius: 14,
//                       offset: const Offset(0, 8),
//                     ),
//                   ],
//                 ),
//                 padding: const EdgeInsets.all(12),
//                 child: bottom!,
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   @override
//   bool shouldRebuild(covariant DetailsArcHeaderSliver oldDelegate) {
//     return oldDelegate.title != title ||
//         oldDelegate.bottom != bottom ||
//         oldDelegate.minHeight != minHeight ||
//         oldDelegate.maxHeight != maxHeight ||
//         oldDelegate.onAction != onAction ||
//         oldDelegate.actionIcon != actionIcon;
//   }
// }
