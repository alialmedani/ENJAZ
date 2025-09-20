import 'package:enjaz/features/staff/data/model/staff_order.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';

class StatusPill extends StatelessWidget {
  final StaffOrderStatus status;
  final bool scheduled;
  const StatusPill({super.key, required this.status, this.scheduled = false});

  @override
  Widget build(BuildContext context) {
    Color bg, fg;
    switch (status) {
      case StaffOrderStatus.pending:
        bg = AppColors.lightOrange.withOpacity(.15);
        fg = AppColors.lightOrange;
        break;
      case StaffOrderStatus.inProgress:
        bg = AppColors.xprimaryColor.withOpacity(.15);
        fg = AppColors.xprimaryColor;
        break;
      case StaffOrderStatus.ready:
        bg = AppColors.lightGreen.withOpacity(.15);
        fg = AppColors.green32;
        break;
      case StaffOrderStatus.delivered:
        bg = AppColors.greyE5.withOpacity(.45);
        fg = AppColors.secondPrimery;
        break;
    }
    final key = _key(status, scheduled);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        key.tr(),
        style: TextStyle(color: fg, fontWeight: FontWeight.w700),
      ),
    );
  }

  String _key(StaffOrderStatus s, bool scheduled) {
    if (!scheduled) {
      switch (s) {
        case StaffOrderStatus.pending:
          return 'status_pending';
        case StaffOrderStatus.inProgress:
          return 'status_in_progress';
        case StaffOrderStatus.ready:
          return 'status_ready';
        case StaffOrderStatus.delivered:
          return 'status_delivered';
      }
    } else {
      switch (s) {
        case StaffOrderStatus.pending:
          return 'scheduled_pending';
        case StaffOrderStatus.inProgress:
          return 'scheduled_in_progress';
        case StaffOrderStatus.ready:
          return 'scheduled_ready';
        case StaffOrderStatus.delivered:
          return 'scheduled_delivered';
      }
    }
  }
}
