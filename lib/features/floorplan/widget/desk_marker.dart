import 'package:easy_localization/easy_localization.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/features/floorplan/data/model/desk_model.dart';
import 'package:enjaz/features/floorplan/widget/presence_dot.dart';
import 'package:flutter/material.dart';

/// A single desk marker rendered on top of the floor-plan image.
///
/// Free desks and occupied desks are visually distinct, and the assigned
/// user name (when present) is shown beneath the label.
class DeskMarker extends StatelessWidget {
  final DeskModel desk;
  final bool busy;
  final VoidCallback? onTap;

  const DeskMarker({super.key, required this.desk, this.busy = false, this.onTap});

  IconData get _icon {
    switch (desk.deskType) {
      case DeskType.room:
        return Icons.meeting_room_outlined;
      case DeskType.resource:
        return Icons.devices_other_outlined;
      case DeskType.desk:
        return Icons.event_seat_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool free = desk.isFree;
    final Color base = free ? AppColors.green : AppColors.orange;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 132),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: base, width: 1.6),
          boxShadow: [
            BoxShadow(
              color: base.withValues(alpha: 0.30),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: base.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_icon, size: 18, color: base),
                ),
                if (busy)
                  const SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                // Presence dot for occupied desks (top-right of the icon).
                if (!free)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: PresenceDot(status: desk.presenceStatus, size: 12),
                  ),
              ],
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    desk.label ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: AppColors.black23,
                    ),
                  ),
                  Text(
                    free
                        ? 'floorplan_free'.tr()
                        : (desk.assignedUserName ?? 'floorplan_occupied'.tr()),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      color: free ? AppColors.green : AppColors.secondPrimery,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
