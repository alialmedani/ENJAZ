// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'package:enjaz/core/constant/app_colors/app_colors.dart';
// import 'package:enjaz/core/constant/app_padding/app_padding.dart';
// import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
// import 'package:enjaz/core/constant/text_styles/font_size.dart';
// import 'package:enjaz/features/profile/data/model/user_model.dart';

// class HeaderCardPro extends StatefulWidget {
//   final UserModel profile;
//   const HeaderCardPro({super.key, required this.profile});

//   @override
//   State<HeaderCardPro> createState() => _HeaderCardProState();
// }

// class _HeaderCardProState extends State<HeaderCardPro>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _ctrl;

//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 3),
//     )..repeat();
//   }

//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _ctrl,
//       builder: (_, __) {
//         final t = _ctrl.value;
//         final glow = 0.6 + 0.4 * math.sin(t * math.pi * 2);
//         return Container(
//           padding: const EdgeInsets.all(AppPaddingSize.padding_16),
//           decoration: BoxDecoration(
//             color: AppColors.white,
//             borderRadius: BorderRadius.circular(AppPaddingSize.padding_16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(.06),
//                 blurRadius: 16,
//                 offset: const Offset(0, 8),
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               // Avatar مع حلقة متدرجة وPulse
//               SizedBox(
//                 width: 72,
//                 height: 72,
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     Container(
//                       width: 72,
//                       height: 72,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         gradient: SweepGradient(
//                           colors: [
//                             AppColors.darkAccentColor,
//                             AppColors.xorangeColor,
//                             AppColors.darkAccentColor,
//                           ],
//                           stops: const [0.0, 0.5, 1.0],
//                           transform: GradientRotation(t * 2 * math.pi),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       width: 66 + glow, // pulse طفيف
//                       height: 66 + glow,
//                       decoration: BoxDecoration(
//                         color: AppColors.white,
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: AppColors.darkAccentColor.withOpacity(.25),
//                             blurRadius: 18 * glow,
//                             spreadRadius: 1,
//                           ),
//                         ],
//                       ),
//                     ),
//                     CircleAvatar(
//                       radius: 28,
//                       backgroundColor: AppColors.xbackgroundColor,
//                       // يمكنك استبدال الأيقونة بصورة شبكة إن توفرت
//                       child: Icon(
//                         Icons.person,
//                         color: AppColors.secondPrimery,
//                         size: 28,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: AppPaddingSize.padding_12),
//               // نصوص مع Parallax بسيط
//               Expanded(
//                 child: Transform.translate(
//                   offset: Offset(0, math.sin(t * 2 * math.pi) * 0.8),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         widget.profile.name ?? "",
//                         style: AppTextStyle.getBoldStyle(
//                           fontSize: AppFontSize.size_16,
//                           color: AppColors.black23,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Opacity(
//                         opacity: 0.92,
//                         child: Text(
//                           "floor: ${widget.profile.floor ?? '-'} • office: ${widget.profile.office ?? '-'}",
//                           style: AppTextStyle.getRegularStyle(
//                             fontSize: AppFontSize.size_12,
//                             color: AppColors.secondPrimery,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
