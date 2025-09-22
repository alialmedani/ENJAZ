import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/app_padding/app_padding.dart';
import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';
import 'package:enjaz/features/order/data/model/order_model.dart';
import 'package:enjaz/features/profile/data/model/user_model.dart';
import './profile_order_details_screen.dart';

class HistoryList extends StatelessWidget {
  const HistoryList({
    super.key,
    required this.orderModel,
    required this.profile,
  });

  final OrderModel orderModel;
  final UserModel profile;

  @override
  Widget build(BuildContext context) {
    final items = orderModel.orderItems ?? const [];
    final dateLabel = _formatDate(orderModel.creationTime);
    final status = orderModel.status ?? 0;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, (1 - value) * 20),
          child: child,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ProfileOrderDetailsScreen(
                order: orderModel,
                profile: profile,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.greyE5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppPaddingSize.padding_16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StatusGlyph(status: status),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${items.length} ${'items'.tr()}',
                              style: AppTextStyle.getBoldStyle(
                                fontSize: AppFontSize.size_14,
                                color: AppColors.black23,
                              ),
                            ),
                          ),
                          _StatusChip(status: status),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 16,
                            color: AppColors.secondPrimery,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            dateLabel,
                            style: AppTextStyle.getRegularStyle(
                              fontSize: AppFontSize.size_12,
                              color: AppColors.secondPrimery,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _QuickSummary(items: items),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.secondPrimery,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusGlyph extends StatelessWidget {
  const _StatusGlyph({required this.status});

  final int status;

  @override
  Widget build(BuildContext context) {
    final (label, color, icon) = _mapStatus(status);
    return Container(
      width: 48,
      constraints: const BoxConstraints(minWidth: 48, minHeight: 72),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withValues(alpha: 0.22),
            color.withValues(alpha: 0.05),
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 20),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyle.getRegularStyle(
              fontSize: AppFontSize.size_10,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final int status;

  @override
  Widget build(BuildContext context) {
    final (label, color, icon) = _mapStatus(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyle.getBoldStyle(
              fontSize: AppFontSize.size_12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickSummary extends StatelessWidget {
  const _QuickSummary({required this.items});

  final List<OrderItems> items;

  @override
  Widget build(BuildContext context) {
    final primary = items.isNotEmpty ? items.first : null;
    final drinkName = primary?.drink?.name ?? '';
    final sugar = primary?.sugarLevel;

    return Wrap(
      spacing: 10,
      runSpacing: 6,
      children: [
        _SummaryChip(label: 'history_qty'.tr(args: ['${items.length}'])),
        if (drinkName.isNotEmpty) _SummaryChip(label: drinkName),
        if (sugar != null)
          _SummaryChip(label: 'history_sugar'.tr(args: ['${sugar}'])),
      ],
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.xbackgroundColor3,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: AppTextStyle.getRegularStyle(
          fontSize: AppFontSize.size_11,
          color: AppColors.black23,
        ),
      ),
    );
  }
}

(String, Color, IconData) _mapStatus(int status) {
  switch (status) {
    case 1:
      return ('preparing'.tr(), AppColors.xpurpleColor, Icons.coffee);
    case 2:
      return ('on_the_way'.tr(), AppColors.xorangeColor, Icons.delivery_dining);
    case 3:
      return ('completed'.tr(), Colors.green.shade600, Icons.check_circle);
    case 4:
      return ('canceled'.tr(), Colors.red.shade600, Icons.cancel);
    default:
      return ('pending'.tr(), AppColors.secondPrimery, Icons.hourglass_bottom);
  }
}

String _formatDate(String? iso) {
  if (iso == null || iso.isEmpty) return '';
  try {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    return DateFormat('d MMM yyyy - HH:mm').format(dt);
  } catch (_) {
    return iso;
  }
}

