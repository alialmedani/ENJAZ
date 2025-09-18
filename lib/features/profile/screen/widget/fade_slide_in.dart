import 'package:flutter/material.dart';

class FadeSlideIn extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final double dy;
  const FadeSlideIn({
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 420),
    this.dy = 12,
    super.key,
  });

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn> {
  bool _show = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) setState(() => _show = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _show ? 1 : 0,
      duration: widget.duration,
      curve: Curves.easeOutCubic,
      child: AnimatedSlide(
        offset: _show ? Offset.zero : Offset(0, widget.dy / 100),
        duration: widget.duration,
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}
