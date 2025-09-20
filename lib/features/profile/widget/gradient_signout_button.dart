// // lib/features/profile/widgets/gradient_signout_button.dart
// import 'dart:ui';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:enjaz/core/classes/cashe_helper.dart';
// import 'package:enjaz/core/constant/end_points/cashe_helper_constant.dart';
// import 'package:enjaz/core/constant/app_colors/app_colors.dart';
// import 'package:enjaz/features/auth/screen/login_screen.dart';

// class GradientSignOutButton extends StatefulWidget {
//   const GradientSignOutButton({
//     super.key,
//     this.width,
//     this.height = 48,
//     this.enableSlide = true, // لو بدك Tap فقط: خليها false
//     this.toastDuration = const Duration(milliseconds: 1100),
//   });

//   final double? width;
//   final double height;
//   final bool enableSlide;
//   final Duration toastDuration;

//   @override
//   State<GradientSignOutButton> createState() => _GradientSignOutButtonState();
// }

// class _GradientSignOutButtonState extends State<GradientSignOutButton>
//     with TickerProviderStateMixin {
//   double _pos = 0.0; // 0..1 للسحب
//   bool _busy = false;
//   late final AnimationController _resetCtrl;

//   @override
//   void initState() {
//     super.initState();
//     _resetCtrl =
//         AnimationController(
//           vsync: this,
//           duration: const Duration(milliseconds: 180),
//         )..addListener(() {
//           if (mounted) setState(() => _pos = _resetCtrl.value);
//         });
//   }

//   @override
//   void dispose() {
//     _resetCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _logout() async {
//     if (!mounted || _busy) return;
//     setState(() => _busy = true);

//     try {
//       await CacheHelper.box.delete(accessToken);
//       await CacheHelper.box.delete(refreshToken);
//       await CacheHelper.box.delete('current_user_phone');
//       await CacheHelper.box.delete('current_user_role');

//       await _showNeoToast(context, 'signed_out'.tr());

//       if (!mounted) return;
//       Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (_) => const LoginScreen()),
//         (r) => false,
//       );
//     } catch (_) {
//       await _showNeoToast(
//         context,
//         'Something went wrong',
//         error: true,
//         duration: const Duration(milliseconds: 1400),
//       );
//     } finally {
//       if (mounted) {
//         setState(() {
//           _busy = false;
//           _pos = 0.0;
//         });
//       }
//     }
//   }

//   Future<void> _showNeoToast(
//     BuildContext context,
//     String text, {
//     bool error = false,
//     Duration? duration,
//   }) async {
//     final overlay = Overlay.of(context);
//     if (overlay == null) return;

//     final g1 = error ? Colors.red.shade600 : AppColors.darkAccentColor;
//     final g2 = error ? Colors.orange : AppColors.xorangeColor;

//     // ✅ هاد الكنترولر مستقل عن _resetCtrl، ومسموح لأننا صرنا TickerProviderStateMixin
//     final fadeCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 220),
//       reverseDuration: const Duration(milliseconds: 180),
//     );
//     final curved = CurvedAnimation(
//       parent: fadeCtrl,
//       curve: Curves.easeOutCubic,
//     );

//     late OverlayEntry entry;
//     entry = OverlayEntry(
//       builder: (_) => Positioned(
//         left: 16,
//         right: 16,
//         bottom: 28,
//         child: FadeTransition(
//           opacity: curved,
//           child: _NeoToast(text: text, g1: g1, g2: g2),
//         ),
//       ),
//     );

//     overlay.insert(entry);
//     await fadeCtrl.forward();
//     await Future.delayed(duration ?? widget.toastDuration);
//     await fadeCtrl.reverse();
//     entry.remove();
//     fadeCtrl.dispose();
//   }

//   void _animateBack() {
//     _resetCtrl
//       ..stop()
//       ..value = _pos
//       ..animateTo(0.0, curve: Curves.easeOutCubic);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = widget.width ?? 220.0;
//     final h = widget.height;
//     final radius = h / 2;

//     final g1 = AppColors.darkAccentColor;
//     final g2 = AppColors.xorangeColor;

//     return SizedBox(
//       width: width,
//       height: h,
//       child: GestureDetector(
//         onTap: () async {
//           if (_busy) return;
//           HapticFeedback.selectionClick();
//           await _showNeoToast(
//             context,
//             'sign_out'.tr(),
//             duration: const Duration(milliseconds: 700),
//           );
//           await _logout();
//         },
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(radius),
//           child: Stack(
//             children: [
//               // خلفية كبسولة متدرجة
//               Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(colors: [g1, g2]),
//                   boxShadow: [
//                     BoxShadow(
//                       color: g1.withOpacity(.22),
//                       blurRadius: 12,
//                       offset: const Offset(0, 6),
//                     ),
//                   ],
//                 ),
//               ),
//               // طبقة زجاجية خفيفة
//               BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
//                 child: Container(color: Colors.white.withOpacity(.06)),
//               ),
//               // النص بالوسط
//               Center(
//                 child: AnimatedOpacity(
//                   opacity: _busy ? 0.0 : 1.0,
//                   duration: const Duration(milliseconds: 140),
//                   child: Text(
//                     'sign_out'.tr(),
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w800,
//                     ),
//                   ),
//                 ),
//               ),

//               // مقبض السحب (اختياري)
//               if (widget.enableSlide && !_busy)
//                 LayoutBuilder(
//                   builder: (context, c) {
//                     final w = c.maxWidth;
//                     final pad = 4.0;
//                     final knob = h - pad * 2;
//                     final maxDx = w - knob - pad;
//                     final dx = pad + (_pos * maxDx);

//                     return Stack(
//                       children: [
//                         Positioned.fill(
//                           child: IgnorePointer(
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     Colors.white.withOpacity(.10 + .20 * _pos),
//                                     Colors.white.withOpacity(.06),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           left: dx,
//                           top: pad,
//                           bottom: pad,
//                           child: GestureDetector(
//                             behavior: HitTestBehavior.translucent,
//                             onHorizontalDragUpdate: (d) {
//                               final plc = (dx + d.delta.dx).clamp(
//                                 pad,
//                                 maxDx + pad,
//                               );
//                               setState(
//                                 () => _pos = ((plc - pad) / maxDx).clamp(
//                                   0.0,
//                                   1.0,
//                                 ),
//                               );
//                             },
//                             onHorizontalDragEnd: (_) async {
//                               if (_pos >= 0.92) {
//                                 HapticFeedback.mediumImpact();
//                                 await _showNeoToast(
//                                   context,
//                                   'sign_out'.tr(),
//                                   duration: const Duration(milliseconds: 600),
//                                 );
//                                 await _logout();
//                               } else {
//                                 _animateBack();
//                               }
//                             },
//                             child: Container(
//                               width: knob,
//                               height: knob,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(12),
//                                 border: Border.all(
//                                   color: Colors.white.withOpacity(.7),
//                                   width: 1,
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(.18),
//                                     blurRadius: 10,
//                                     offset: const Offset(0, 5),
//                                   ),
//                                 ],
//                               ),
//                               child: ShaderMask(
//                                 shaderCallback: (r) => LinearGradient(
//                                   colors: [g1, g2],
//                                 ).createShader(r),
//                                 child: const Icon(
//                                   Icons.arrow_forward_rounded,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),

//               // لودينغ فوق الكل
//               if (_busy)
//                 const Center(
//                   child: SizedBox(
//                     width: 22,
//                     height: 22,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2.4,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// توست زجاجي أنيق بألوان التدرّج
// class _NeoToast extends StatelessWidget {
//   final String text;
//   final Color g1, g2;
//   const _NeoToast({required this.text, required this.g1, required this.g2});

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(14),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(.20),
//             border: Border.all(color: Colors.white.withOpacity(.55)),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(.08),
//                 blurRadius: 12,
//                 offset: const Offset(0, 6),
//               ),
//             ],
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 22,
//                 height: 22,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(6),
//                   gradient: LinearGradient(colors: [g1, g2]),
//                 ),
//                 child: const Icon(
//                   Icons.logout_rounded,
//                   color: Colors.white,
//                   size: 14,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 text,
//                 style: const TextStyle(
//                   color: Colors.black87,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
