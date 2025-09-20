// // lib/features/profile/widgets/fade_slide_in.dart
// import 'package:enjaz/core/constant/app_colors/app_colors.dart';
// import 'package:flutter/material.dart';

// class FadeSlideIn extends StatefulWidget {
//   final Widget child;
//   final Duration delay;
//   final Duration duration;
//   final double dy;
//   const FadeSlideIn({
//     super.key,
//     required this.child,
//     this.delay = Duration.zero,
//     this.duration = const Duration(milliseconds: 420),
//     this.dy = 12,
//   });
//   @override
//   State<FadeSlideIn> createState() => _FadeSlideInState();
// }

// class _FadeSlideInState extends State<FadeSlideIn> {
//   bool _show = false;
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(widget.delay, () {
//       if (mounted) setState(() => _show = true);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedOpacity(
//       opacity: _show ? 1 : 0,
//       duration: widget.duration,
//       curve: Curves.easeOutCubic,
//       child: AnimatedSlide(
//         offset: _show ? Offset.zero : Offset(0, widget.dy / 100),
//         duration: widget.duration,
//         curve: Curves.easeOutCubic,
//         child: widget.child,
//       ),
//     );
//   }
// }
// // lib/features/profile/widgets/micro_icon_button.dart
 
// class FadeScaleIconButton extends StatefulWidget {
//   final IconData icon;
//   final VoidCallback onTap;
//   const FadeScaleIconButton({super.key, required this.icon, required this.onTap});
//   @override
//   State<FadeScaleIconButton> createState() => _FadeScaleIconButtonState();
// }

// class _FadeScaleIconButtonState extends State<FadeScaleIconButton> with SingleTickerProviderStateMixin {
//   late final AnimationController _ctrl;
//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 140));
//   }
//   @override
//   void dispose() { _ctrl.dispose(); super.dispose(); }
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTapDown: (_) => _ctrl.forward(),
//       onTapCancel: () => _ctrl.reverse(),
//       onTapUp: (_) { _ctrl.reverse(); widget.onTap(); },
//       child: ScaleTransition(
//         scale: Tween<double>(begin: 1.0, end: 0.92).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic)),
//         child: Icon(widget.icon, color: AppColors.darkSubHeadingColor1),
//       ),
//     );
//   }
// }
