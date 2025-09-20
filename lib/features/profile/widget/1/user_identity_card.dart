// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'package:enjaz/core/constant/app_colors/app_colors.dart';
// import 'package:enjaz/core/constant/app_padding/app_padding.dart';
// import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
// import 'package:enjaz/core/constant/text_styles/font_size.dart';
// import 'package:enjaz/features/profile/data/model/user_model.dart';

// class UserIdentityCard extends StatefulWidget {
//   final UserModel user;
//   final ImageProvider? avatarImage;
//   final bool animated; // اختياري

//   const UserIdentityCard({
//     super.key,
//     required this.user,
//     this.avatarImage,
//     this.animated = false,
//   });

//   @override
//   State<UserIdentityCard> createState() => _UserIdentityCardState();
// }

// class _UserIdentityCardState extends State<UserIdentityCard>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _ctrl;

//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 3),
//     );
//     if (widget.animated) _ctrl.repeat();
//   }

//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }

//   String _fullName(UserModel u) {
//     final name = (u.name ?? '').trim();
//     final sur = (u.surname ?? '').trim();
//     if (name.isEmpty && sur.isEmpty) return (u.userName ?? '').trim();
//     return [name, sur].where((e) => e.isNotEmpty).join(' ');
//   }

//   String _initials(UserModel u) {
//     final n = (u.name ?? '').trim();
//     final s = (u.surname ?? '').trim();
//     final uName = (u.userName ?? '').trim();
//     final base = (n.isNotEmpty || s.isNotEmpty) ? '$n $s' : uName;
//     final parts = base
//         .split(RegExp(r'\s+'))
//         .where((p) => p.isNotEmpty)
//         .take(2)
//         .toList();
//     if (parts.isEmpty) return '?';
//     return parts.map((p) => p.characters.first.toUpperCase()).join();
//   }

//   String _subtitle(UserModel u) {
//     final email = (u.email ?? '').trim();
//     if (email.isNotEmpty) return email;
//     final userName = (u.userName ?? '').trim();
//     return userName;
//   }

//   String _floorOffice(UserModel u) {
//     final f = u.floor;
//     final o = (u.office ?? '').trim();
//     final parts = <String>[];
//     if (f != null) parts.add('Floor $f');
//     if (o.isNotEmpty) parts.add('Office $o');
//     return parts.join(' • ');
//   }

//   @override
//   Widget build(BuildContext context) {
//     final initials = _initials(widget.user);
//     final title = _fullName(widget.user);
//     final sub = _subtitle(widget.user);
//     final meta = _floorOffice(widget.user);
//     final active = widget.user.isActive == true;

//     return Container(
//       padding: const EdgeInsets.all(AppPaddingSize.padding_16),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(AppPaddingSize.padding_16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.06),
//             blurRadius: 14,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           // Avatar + حلقة متدرجة اختيارية
//           SizedBox(
//             width: 72,
//             height: 72,
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 AnimatedBuilder(
//                   animation: _ctrl,
//                   builder: (_, __) {
//                     final t = widget.animated ? _ctrl.value : 0.0;
//                     return Container(
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
//                     );
//                   },
//                 ),
//                 CircleAvatar(
//                   radius: 30,
//                   backgroundColor: AppColors.xbackgroundColor,
//                   backgroundImage: widget.avatarImage,
//                   child: widget.avatarImage == null
//                       ? Text(
//                           initials,
//                           style: AppTextStyle.getBoldStyle(
//                             fontSize: AppFontSize.size_16,
//                             color: AppColors.secondPrimery,
//                           ),
//                         )
//                       : null,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: AppPaddingSize.padding_12),

//           // نصوص
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title.isEmpty ? '-' : title,
//                   style: AppTextStyle.getBoldStyle(
//                     fontSize: AppFontSize.size_16,
//                     color: AppColors.black23,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 if (sub.isNotEmpty)
//                   Text(
//                     sub,
//                     style: AppTextStyle.getRegularStyle(
//                       fontSize: AppFontSize.size_12,
//                       color: AppColors.secondPrimery,
//                     ),
//                   ),
//                 if (meta.isNotEmpty)
//                   Text(
//                     meta,
//                     style: AppTextStyle.getRegularStyle(
//                       fontSize: AppFontSize.size_12,
//                       color: AppColors.secondPrimery,
//                     ),
//                   ),
//               ],
//             ),
//           ),

//           // حالة Active/Inactive
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//             decoration: BoxDecoration(
//               color: (active ? Colors.green : Colors.red).withValues(
//                 alpha: 0.12,
//               ),
//               borderRadius: BorderRadius.circular(999),
//             ),
//             child: Text(
//               active ? 'Active' : 'Inactive',
//               style: AppTextStyle.getBoldStyle(
//                 fontSize: AppFontSize.size_12,
//                 color: active ? Colors.green.shade700 : Colors.red.shade700,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
