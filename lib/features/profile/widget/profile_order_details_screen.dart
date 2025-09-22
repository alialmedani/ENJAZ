import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:intl/intl.dart';

import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/app_padding/app_padding.dart';
import 'package:enjaz/core/constant/enum/enum.dart';
import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';
import 'package:enjaz/features/order/data/model/order_model.dart';
import 'package:enjaz/features/profile/data/model/user_model.dart';

class ProfileOrderDetailsScreen extends StatelessWidget {
  const ProfileOrderDetailsScreen({
    super.key,
    required this.order,
    required this.profile,
  });

  final OrderModel order;
  final UserModel profile;

  @override
  Widget build(BuildContext context) {
    final items = order.orderItems ?? const <OrderItems>[];
    final dateLabel = _formatDate(order.creationTime);
    final statusVisual = _statusVisual(order.status ?? 0);
    final displayProfile = order.customerUser ?? profile;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const _DecorativeBackground(),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // _OrderHeader(
              //   status: statusVisual,
              //   createdAtLabel: dateLabel,
              //   order: order,
              //   profile: displayProfile,
              // ),
              SliverToBoxAdapter(
                child: _ContentSheet(
                  children: [
                    _SummaryCard(
                      status: statusVisual,
                      createdAtLabel: dateLabel,
                      order: order,
                      profile: displayProfile,
                    ),
                    const SizedBox(height: 28),
                    _SectionTitle(
                      title: 'items'.tr(),
                      subtitle: items.isEmpty
                          ? 'items_empty_subtitle'.tr()
                          : 'items_list_subtitle'.tr(),
                    ),
                    const SizedBox(height: 18),
                    if (items.isEmpty)
                      const _EmptyItemsPlaceholder()
                    else ...[
                      for (int i = 0; i < items.length; i++)
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: i == items.length - 1 ? 0 : 20,
                          ),
                          child: _TimelineItemCard(
                            item: items[i],
                            index: i,
                            isLast: i == items.length - 1,
                          ),
                        ),
                    ],
                    if (dateLabel.isNotEmpty) ...[
                      const SizedBox(height: 32),
                      _SectionTitle(
                        title: 'created_at'.tr(),
                        subtitle: 'created_at_hint'.tr(),
                      ),
                      const SizedBox(height: 16),
                      _InfoCard(icon: Icons.schedule, lines: [dateLabel]),
                    ],
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DecorativeBackground extends StatelessWidget {
  const _DecorativeBackground();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: const Alignment(-0.2, -1),
              end: const Alignment(0.45, 1.1),
              colors: [
                AppColors.xbackgroundColor.withValues(alpha: 0.85),
                Colors.white,
              ],
            ),
          ),
          child: Stack(
            children: [
              _FrostedBlob(
                alignment: const Alignment(-1.2, -0.9),
                color: AppColors.xprimaryColor,
                size: 260,
                blur: 60,
                opacity: 0.28,
              ),
              _FrostedBlob(
                alignment: const Alignment(1.15, -0.6),
                color: AppColors.xorangeColor,
                size: 220,
                blur: 52,
                opacity: 0.22,
              ),
              _FrostedBlob(
                alignment: const Alignment(-0.8, 1.05),
                color: AppColors.xbackgroundColor2,
                size: 320,
                blur: 68,
                opacity: 0.16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FrostedBlob extends StatelessWidget {
  const _FrostedBlob({
    required this.alignment,
    required this.color,
    this.size = 240,
    this.blur = 48,
    this.opacity = 0.22,
  });

  final Alignment alignment;
  final Color color;
  final double size;
  final double blur;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final tinted = color.withValues(alpha: opacity);
    return Align(
      alignment: alignment,
      child: SizedBox(
        width: size,
        height: size,
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [tinted, tinted.withValues(alpha: 0)],
                  stops: const [0.1, 1],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final hasSubtitle = subtitle != null && subtitle!.trim().isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyle.getBoldStyle(
            fontSize: AppFontSize.size_18,
            color: AppColors.black23,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 54,
          height: 3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: LinearGradient(
              colors: [AppColors.xprimaryColor, AppColors.xorangeColor],
            ),
          ),
        ),
        if (hasSubtitle) ...[
          const SizedBox(height: 10),
          Text(
            subtitle!.trim(),
            style: AppTextStyle.getRegularStyle(
              fontSize: AppFontSize.size_12,
              color: AppColors.secondPrimery,
            ),
          ),
        ],
      ],
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white.withValues(alpha: 0.85),
          border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 18, color: AppColors.secondPrimery),
      ),
    );
  }
}

class _ContentSheet extends StatelessWidget {
  const _ContentSheet({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.94),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
            border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 36, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}

//akhden
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.status,
    required this.createdAtLabel,
    required this.order,
    required this.profile,
  });

  final _StatusVisual status;
  final String createdAtLabel;
  final OrderModel order;
  final UserModel profile;

  @override
  Widget build(BuildContext context) {
    final floorLabel = order.floorName?.toString() ?? '-';
    final officeLabel = order.officeName?.trim().isNotEmpty == true
        ? order.officeName!.trim()
        : '-';
    final contact = profile.phoneNumber?.trim().isNotEmpty == true
        ? profile.phoneNumber!.trim()
        : profile.name?.trim().isNotEmpty == true
        ? profile.name!.trim()
        : 'not_provided'.tr();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          begin: const Alignment(-0.2, -0.6),
          end: const Alignment(0.8, 1.0),
          colors: [
            Colors.white,
            AppColors.xbackgroundColor.withValues(alpha: 0.9),
          ],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: status.color.withValues(alpha: 0.08),
            blurRadius: 28,
            offset: const Offset(0, 18),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StatusBadge(status: status),
              const Spacer(),
              if (createdAtLabel.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'created_at'.tr(),
                      style: AppTextStyle.getRegularStyle(
                        fontSize: AppFontSize.size_11,
                        color: AppColors.secondPrimery,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      createdAtLabel,
                      style: AppTextStyle.getBoldStyle(
                        fontSize: AppFontSize.size_12,
                        color: AppColors.black23,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.6)),
          const SizedBox(height: 20),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              _MetricChip(
                icon: Icons.person_outline,
                label: 'customer'.tr(),
                value: profile.name?.trim().isNotEmpty == true
                    ? profile.name!.trim()
                    : profile.userName ?? 'guest'.tr(),
              ),
              _MetricChip(
                icon: Icons.location_city_outlined,
                label: 'floor'.tr(),
                value: floorLabel,
              ),
              _MetricChip(
                icon: Icons.apartment_outlined,
                label: 'office'.tr(),
                value: officeLabel,
              ),
              _MetricChip(
                icon: Icons.call_outlined,
                label: 'contact'.tr(),
                value: contact,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            AppColors.xbackgroundColor3.withValues(alpha: 0.7),
          ],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.xprimaryColor.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 18, color: AppColors.xprimaryColor),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: AppTextStyle.getRegularStyle(
                    fontSize: AppFontSize.size_11,
                    color: AppColors.secondPrimery,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.getBoldStyle(
                    fontSize: AppFontSize.size_14,
                    color: AppColors.black23,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyItemsPlaceholder extends StatelessWidget {
  const _EmptyItemsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.xbackgroundColor3, Colors.white],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.xprimaryColor.withValues(alpha: 0.24),
                  AppColors.xorangeColor.withValues(alpha: 0.18),
                ],
              ),
            ),
            child: Icon(
              Icons.local_cafe_outlined,
              size: 28,
              color: AppColors.xprimaryColor,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'no_drinks_attached_title'.tr(),
            textAlign: TextAlign.center,
            style: AppTextStyle.getBoldStyle(
              fontSize: AppFontSize.size_15,
              color: AppColors.black23,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'no_drinks_attached_sub'.tr(),
            textAlign: TextAlign.center,
            style: AppTextStyle.getRegularStyle(
              fontSize: AppFontSize.size_12,
              color: AppColors.secondPrimery,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineItemCard extends StatelessWidget {
  const _TimelineItemCard({
    required this.item,
    required this.index,
    required this.isLast,
  });

  final OrderItems item;
  final int index;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.xprimaryColor;
    final drinkName = item.drink?.name?.trim().isNotEmpty == true
        ? item.drink!.name!.trim()
        : item.drinkId?.trim().isNotEmpty == true
        ? item.drinkId!.trim()
        : 'signature_drink'.tr();
    final createdAt = _formatDate(item.creationTime);
    final sugarLevel = SugarLevel.fromInt(item.sugarLevel);
    final sugarLabel = _sugarLevelDisplay(sugarLevel);
    final quantity = item.quantity ?? 1;
    final notes = item.notes?.trim();

    final tags = <String>[];
    if (quantity > 0) {
      tags.add('qty_x'.tr(args: ['$quantity']));
    }
    if (sugarLabel.isNotEmpty) {
      tags.add('$sugarLabel ${'sugar'.tr()}');
    }



    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 360 + index * 80),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, (1 - value) * 24),
          child: child,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [accent, AppColors.xorangeColor],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.32),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
              if (!isLast)
                Container(
                  width: 3,
                  height: 96,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        accent.withValues(alpha: 0.4),
                        accent.withValues(alpha: 0.06),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    AppColors.xbackgroundColor3.withValues(alpha: 0.7),
                  ],
                ),
                border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              drinkName,
                              style: AppTextStyle.getBoldStyle(
                                fontSize: AppFontSize.size_16,
                                color: AppColors.black23,
                              ),
                            ),
                            if (createdAt.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                createdAt,
                                style: AppTextStyle.getRegularStyle(
                                  fontSize: AppFontSize.size_11,
                                  color: AppColors.secondPrimery,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (tags.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: tags
                          .map((tag) => _InfoTag(label: tag))
                          .toList(),
                    ),
                  ],
                  if (notes != null && notes.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Text(
                      'barista_notes'.tr(),
                      style: AppTextStyle.getBoldStyle(
                        fontSize: AppFontSize.size_12,
                        color: AppColors.black23,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notes,
                      style: AppTextStyle.getRegularStyle(
                        fontSize: AppFontSize.size_12,
                        color: AppColors.secondPrimery,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _sugarLevelDisplay(SugarLevel? level) {
  if (level == null) return '';
  switch (level) {
    case SugarLevel.none:
      return 'sugar_none'.tr();
    case SugarLevel.light:
      return 'sugar_light'.tr();
    case SugarLevel.medium:
      return 'sugar_medium'.tr();
    case SugarLevel.high:
      return 'sugar_high'.tr();
  }
}

class _InfoTag extends StatelessWidget {
  const _InfoTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            AppColors.xprimaryColor.withValues(alpha: 0.18),
            AppColors.xorangeColor.withValues(alpha: 0.14),
          ],
        ),
        border: Border.all(
          color: AppColors.xprimaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        label,
        style: AppTextStyle.getRegularStyle(
          fontSize: AppFontSize.size_12,
          color: AppColors.xprimaryColor,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final _StatusVisual status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: LinearGradient(
          colors: [
            status.color.withValues(alpha: 0.22),
            status.color.withValues(alpha: 0.12),
          ],
        ),
        border: Border.all(color: status.color.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: status.color.withValues(alpha: 0.16),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            alignment: Alignment.center,
            child: Icon(status.icon, size: 14, color: status.color),
          ),
          const SizedBox(width: 10),
          Text(
            status.label,
            style: AppTextStyle.getBoldStyle(
              fontSize: AppFontSize.size_13,
              color: status.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusVisual {
  const _StatusVisual({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;
}

_StatusVisual _statusVisual(int status) {
  switch (status) {
    case 1:
      return _StatusVisual(
        label: 'preparing'.tr(),
        color: AppColors.xpurpleColor,
        icon: Icons.coffee,
      );
    case 2:
      return _StatusVisual(
        label: 'on_the_way'.tr(),
        color: AppColors.xorangeColor,
        icon: Icons.delivery_dining,
      );
    case 3:
      return _StatusVisual(
        label: 'completed'.tr(),
        color: Colors.green.shade600,
        icon: Icons.check_circle,
      );
    case 4:
      return _StatusVisual(
        label: 'canceled'.tr(),
        color: Colors.red.shade600,
        icon: Icons.cancel,
      );
    default:
      return _StatusVisual(
        label: 'pending'.tr(),
        color: AppColors.secondPrimery,
        icon: Icons.hourglass_bottom,
      );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.icon, required this.lines});

  final IconData icon;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPaddingSize.padding_18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            AppColors.xbackgroundColor3.withValues(alpha: 0.7),
          ],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.xprimaryColor.withValues(alpha: 0.16),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: AppColors.xprimaryColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: lines
                  .where((line) => line.trim().isNotEmpty)
                  .map(
                    (line) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        line.trim(),
                        style: AppTextStyle.getRegularStyle(
                          fontSize: AppFontSize.size_13,
                          color: AppColors.black23,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class SugarAmountSection extends StatelessWidget {
  const SugarAmountSection({
    super.key,
    required this.color,
    required this.sugarLevel,
    required this.onChanged,
    required this.pad,
  });

  final Color color;
  final SugarLevel sugarLevel;
  final ValueChanged<SugarLevel> onChanged;
  final double pad;

  void _updateFromLocal(Offset local, double width) {
    final left = pad;
    final right = width - pad;
    final dx = local.dx.clamp(left, right);
    final t = ((dx - left) / (right - left)).toDouble();

    SugarLevel newLevel;
    if (t <= 0.25) {
      newLevel = SugarLevel.none;
    } else if (t <= 0.50) {
      newLevel = SugarLevel.light;
    } else if (t <= 0.75) {
      newLevel = SugarLevel.medium;
    } else {
      newLevel = SugarLevel.high;
    }

    onChanged(newLevel);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (d) => _updateFromLocal(d.localPosition, width),
            onPanDown: (d) => _updateFromLocal(d.localPosition, width),
            onPanUpdate: (d) => _updateFromLocal(d.localPosition, width),
            child: CustomPaint(
              size: Size(width, 120),
              painter: SugarArcPainter(
                color: color,
                sugarLevel: sugarLevel,
                pad: pad,
              ),
            ),
          );
        },
      ),
    );
  }
}

class SugarArcPainter extends CustomPainter {
  SugarArcPainter({
    required this.color,
    required this.sugarLevel,
    this.pad = 24.0,
  });

  final Color color;
  final SugarLevel sugarLevel;
  final double pad;

  double get percent {
    switch (sugarLevel) {
      case SugarLevel.none:
        return 0.0;
      case SugarLevel.light:
        return 0.33;
      case SugarLevel.medium:
        return 0.67;
      case SugarLevel.high:
        return 1.0;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final baseY = size.height * .68;
    final controlY = size.height * .24;
    final left = Offset(pad, baseY);
    final right = Offset(size.width - pad, baseY);
    final control = Offset(size.width / 2, controlY);

    final path = Path()
      ..moveTo(left.dx, left.dy)
      ..quadraticBezierTo(control.dx, control.dy, right.dx, right.dy);

    final trackPaint = Paint()
      ..color = color.withValues(alpha: .18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, trackPaint);

    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;

    final markerPositions = [0.0, 0.33, 0.67, 1.0];
    final markerPaint = Paint()
      ..color = color.withValues(alpha: .45)
      ..style = PaintingStyle.fill;

    for (final pos in markerPositions) {
      final tan = metrics.first.getTangentForOffset(metrics.first.length * pos);
      if (tan != null) {
        final p = tan.position;
        canvas.drawCircle(p, 3, markerPaint);
      }
    }

    final metric = metrics.first;
    final to = (metric.length * percent.clamp(0.0, 1.0)).clamp(
      0.0,
      metric.length,
    );

    final fillPath = metric.extractPath(0.0, to);
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(fillPath, fillPaint);

    final tan = metric.getTangentForOffset(to);
    if (tan != null) {
      final p = tan.position;
      canvas.drawShadow(
        Path()..addOval(Rect.fromCircle(center: p, radius: 9)),
        Colors.black26,
        4,
        false,
      );
      canvas.drawCircle(p, 9, Paint()..color = Colors.white);
      canvas.drawCircle(
        p,
        9,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = color,
      );
    }

    final adjective = _sugarLevelDisplay(sugarLevel); // localized adjective
    final textToPaint = adjective.isEmpty
        ? 'sugar'.tr()
        : '$adjective ${'sugar'.tr()}';

    final painter = TextPainter(
      text: TextSpan(
        text: textToPaint,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Colors.black87,
          fontSize: 14,
        ),
      ),
      textDirection: widgets.TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      Offset((size.width - painter.width) / 2, size.height * 0.1),
    );
  }

  @override
  bool shouldRepaint(covariant SugarArcPainter old) =>
      old.color != color || old.sugarLevel != sugarLevel || old.pad != pad;
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
