import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/features/floorplan/data/model/presence_model.dart';
import 'package:flutter/material.dart';

/// A small colored dot conveying a [PresenceStatus]:
///   AtDesk = green, OnFloor = amber, Away = grey, Offline = hollow ring.
class PresenceDot extends StatelessWidget {
  final PresenceStatus? status;
  final double size;

  const PresenceDot({super.key, required this.status, this.size = 12});

  /// Resolves the fill color for a status (transparent for Offline/null).
  static Color colorFor(PresenceStatus? status) {
    switch (status) {
      case PresenceStatus.atDesk:
        return AppColors.green;
      case PresenceStatus.onFloor:
        return AppColors.orange;
      case PresenceStatus.away:
        return AppColors.grey9A;
      case PresenceStatus.offline:
      case null:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hollow =
        status == null || status == PresenceStatus.offline;
    final Color fill = colorFor(status);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: hollow ? Colors.transparent : fill,
        shape: BoxShape.circle,
        border: Border.all(
          color: hollow ? AppColors.grey9A : Colors.white,
          width: hollow ? 1.4 : 1.6,
        ),
      ),
    );
  }
}
