// lib/features/profile/widgets/skeletons.dart
import 'package:flutter/material.dart';

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _ShimmerBox(height: 88),
        SizedBox(height: 16),
        _ShimmerBox(height: 220),
        SizedBox(height: 16),
        _ShimmerBox(height: 90),
        SizedBox(height: 16),
        _ShimmerBox(height: 56),
      ],
    );
  }
}

class HistorySkeleton extends StatelessWidget {
  const HistorySkeleton({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (_, __) => const _ShimmerBox(height: 120),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: 6,
    );
  }
}

class _ShimmerBox extends StatefulWidget {
  final double height;
  const _ShimmerBox({required this.height});
  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + _ctrl.value * 2, 0),
              end: Alignment(1.0 + _ctrl.value * 2, 0),
              colors: [
                Colors.white.withValues(alpha: .6),
                Colors.white.withValues(alpha: .85),
                Colors.white.withValues(alpha: .6),
              ],
              stops: const [0.2, 0.5, 0.8],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .05),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
        );
      },
    );
  }
}
