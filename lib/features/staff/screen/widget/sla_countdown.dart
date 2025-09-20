import 'dart:async';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';

class SlaCountdown extends StatefulWidget {
  final DateTime dueAt;
  final bool header;
  const SlaCountdown({super.key, required this.dueAt}) : header = false;
  const SlaCountdown.inHeader({super.key, required this.dueAt}) : header = true;

  @override
  State<SlaCountdown> createState() => _SlaCountdownState();
}

class _SlaCountdownState extends State<SlaCountdown> {
  late Timer _t;
  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _t.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final diff = widget.dueAt.difference(now);
    final late = diff.isNegative;
    final d = diff.abs();
    final mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final text = late
        ? 'late_timer'.tr(namedArgs: {'mm': mm, 'ss': ss})
        : 'sla_timer'.tr(namedArgs: {'mm': mm, 'ss': ss});
    final color = late
        ? Colors.red
        : (widget.header ? Colors.white : AppColors.xprimaryColor);
    return Row(
      children: [
        Icon(late ? Icons.timer_off : Icons.timer, size: 18, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(color: color, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
