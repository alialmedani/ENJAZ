import 'package:flutter/material.dart';
import 'package:enjaz/core/constant/app_padding/app_padding.dart';

class ProfileSkeleton extends StatefulWidget {
  const ProfileSkeleton({super.key});
  @override
  State<ProfileSkeleton> createState() => _ProfileSkeletonState();
}

class _ProfileSkeletonState extends State<ProfileSkeleton>
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
    return ListView(
      padding: const EdgeInsets.all(AppPaddingSize.padding_16),
      children: [
        ShimmerBox(ctrl: _ctrl, height: 88),
        const SizedBox(height: 16),
        ShimmerBox(ctrl: _ctrl, height: 220),
        const SizedBox(height: 16),
        ShimmerBox(ctrl: _ctrl, height: 90),
        const SizedBox(height: 16),
        ShimmerBox(ctrl: _ctrl, height: 56),
      ],
    );
  }
}

class HistorySkeleton extends StatefulWidget {
  const HistorySkeleton({super.key});
  @override
  State<HistorySkeleton> createState() => _HistorySkeletonState();
}

class _HistorySkeletonState extends State<HistorySkeleton>
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
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (_, __) => ShimmerBox(ctrl: _ctrl, height: 120),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: 6,
    );
  }
}

class ShimmerBox extends StatelessWidget {
  final AnimationController ctrl;
  final double height;
  const ShimmerBox({super.key, required this.ctrl, required this.height});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, __) {
        return Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + ctrl.value * 2, 0),
              end: Alignment(1.0 + ctrl.value * 2, 0),
              colors: [
                Colors.white.withOpacity(.6),
                Colors.white.withOpacity(.85),
                Colors.white.withOpacity(.6),
              ],
              stops: const [0.2, 0.5, 0.8],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
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
