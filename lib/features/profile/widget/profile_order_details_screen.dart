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
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.xbackgroundColor3,
                    Colors.white,
                  ],
                ),
              ),
            ),
          ),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _OrderHeader(
                status: statusVisual,
                createdAtLabel: dateLabel,
                order: order,
                profile: displayProfile,
              ),
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
                          ? 'No drinks were attached to this order yet'
                          : 'Handcrafted drinks prepared for this request',
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
                        subtitle: 'When the roasting journey began',
                      ),
                      const SizedBox(height: 16),
                      _InfoCard(
                        icon: Icons.schedule,
                        lines: [dateLabel],
                      ),
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
class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    this.subtitle,
  });

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
            fontSize: AppFontSize.size_16,
            color: AppColors.black23,
          ),
        ),
        if (hasSubtitle) ...[
          const SizedBox(height: 6),
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
  const _GlassIconButton({
    required this.icon,
    required this.onTap,
  });

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
          color: Colors.white.withOpacity(0.85),
          border: Border.all(color: Colors.white.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 18,
          color: AppColors.secondPrimery,
        ),
      ),
    );
  }
}
class _OrderHeader extends StatelessWidget {
  const _OrderHeader({
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
    const expandedHeight = 280.0;
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      stretch: true,
      expandedHeight: expandedHeight,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'order_details'.tr(),
          style: AppTextStyle.getBoldStyle(
            fontSize: AppFontSize.size_16,
            color: AppColors.black23,
          ),
        ),
      ),
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.biggest.height;
          final toolbarHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
          final collapseRange = (expandedHeight - toolbarHeight).clamp(1, double.infinity);
          final progress = ((height - toolbarHeight) / collapseRange).clamp(0.0, 1.0);
          final eased = Curves.easeInOut.transform(progress);

          return Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.xbackgroundColor,
                      AppColors.xbackgroundColor3,
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      children: [
                        _GlassIconButton(
                          icon: Icons.arrow_back_ios_new_rounded,
                          onTap: () => Navigator.of(context).maybePop(),
                        ),
                        const Spacer(),
                        _GlassIconButton(
                          icon: Icons.more_horiz,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('more_soon'.tr())),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 24,
                child: Opacity(
                  opacity: eased,
                  child: Transform.translate(
                    offset: Offset(0, 28 * (1 - eased)),
                    child: _HeaderHeroCard(
                      status: status,
                      createdAtLabel: createdAtLabel,
                      order: order,
                      profile: profile,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
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
            color: Colors.white.withOpacity(0.94),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
            border: Border.all(color: Colors.white.withOpacity(0.5)),
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
class _HeaderHeroCard extends StatelessWidget {
  const _HeaderHeroCard({
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
    final location = [
      if (order.floor != null) 'Floor ',
      if (order.office?.trim().isNotEmpty == true) order.office!.trim(),
    ].join(' · ');

    final customerName = profile.name?.trim().isNotEmpty == true
        ? profile.name!.trim()
        : profile.userName ?? 'Guest';

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: Colors.white.withOpacity(0.82),
            border: Border.all(color: Colors.white.withOpacity(0.6)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StatusBadge(status: status),
              const SizedBox(height: 16),
              Text(
                customerName,
                style: AppTextStyle.getBoldStyle(
                  fontSize: AppFontSize.size_20,
                  color: AppColors.black23,
                ),
              ),
              if (location.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 16, color: AppColors.secondPrimery),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        location,
                        style: AppTextStyle.getRegularStyle(
                          fontSize: AppFontSize.size_12,
                          color: AppColors.secondPrimery,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (createdAtLabel.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 14, color: AppColors.secondPrimery),
                    const SizedBox(width: 6),
                    Text(
                      createdAtLabel,
                      style: AppTextStyle.getRegularStyle(
                        fontSize: AppFontSize.size_12,
                        color: AppColors.secondPrimery,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

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
    final floorLabel = order.floor?.toString() ?? '-';
    final officeLabel = order.office?.trim().isNotEmpty == true ? order.office!.trim() : '-';
    final contact = profile.phoneNumber?.trim().isNotEmpty == true
        ? profile.phoneNumber!.trim()
        : profile.email?.trim().isNotEmpty == true
            ? profile.email!.trim()
            : 'Not provided';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.xbackgroundColor3,
            Colors.white,
          ],
        ),
        border: Border.all(color: AppColors.greyE5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _StatusBadge(status: status),
              const Spacer(),
              if (createdAtLabel.isNotEmpty)
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 16, color: AppColors.secondPrimery),
                    const SizedBox(width: 6),
                    Text(
                      createdAtLabel,
                      style: AppTextStyle.getRegularStyle(
                        fontSize: AppFontSize.size_12,
                        color: AppColors.secondPrimery,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 14,
            runSpacing: 12,
            children: [
              _MetricChip(
                icon: Icons.person_outline,
                label: 'Customer',
                value: profile.name?.trim().isNotEmpty == true
                    ? profile.name!.trim()
                    : profile.userName ?? 'Guest',
              ),
              _MetricChip(
                icon: Icons.location_city_outlined,
                label: 'Floor',
                value: floorLabel,
              ),
              _MetricChip(
                icon: Icons.apartment_outlined,
                label: 'Office',
                value: officeLabel,
              ),
              _MetricChip(
                icon: Icons.call_outlined,
                label: 'Contact',
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyE5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.xorangeColor),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTextStyle.getBoldStyle(
                  fontSize: AppFontSize.size_13,
                  color: AppColors.black23,
                ),
              ),
              Text(
                label,
                style: AppTextStyle.getRegularStyle(
                  fontSize: AppFontSize.size_11,
                  color: AppColors.secondPrimery,
                ),
              ),
            ],
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.xbackgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.greyE5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_cafe_outlined, size: 36, color: AppColors.xorangeColor),
          const SizedBox(height: 12),
          Text(
            'No drinks were attached to this order',
            textAlign: TextAlign.center,
            style: AppTextStyle.getBoldStyle(
              fontSize: AppFontSize.size_14,
              color: AppColors.black23,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Once items are added, they will appear here with their preparation notes.',
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
    final accent = AppColors.xorangeColor;
    final drinkName = item.drink?.name?.trim().isNotEmpty == true
        ? item.drink!.name!
        : item.drinkId?.trim().isNotEmpty == true
            ? item.drinkId!.trim()
            : 'Signature drink';
    final sugar = item.sugarLevel;
    final createdAt = _formatDate(item.creationTime);

    final chips = <String>['x'];
    if (sugar != null) chips.add('Sugar ');

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
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: accent.withOpacity(0.35),
                      blurRadius: 14,
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 82,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [accent.withOpacity(0.4), accent.withOpacity(0.06)],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.greyE5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 16,
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
                                fontSize: AppFontSize.size_15,
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
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: chips
                        .map(
                          (chip) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.xbackgroundColor3,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              chip,
                              style: AppTextStyle.getRegularStyle(
                                fontSize: AppFontSize.size_12,
                                color: AppColors.black23,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: status.color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 16, color: status.color),
          const SizedBox(width: 8),
          Text(
            status.label,
            style: AppTextStyle.getBoldStyle(
              fontSize: AppFontSize.size_12,
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
      padding: const EdgeInsets.all(AppPaddingSize.padding_16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppPaddingSize.padding_16),
        border: Border.all(color: AppColors.greyE5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.xorangeColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: lines
                  .map(
                    (line) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        line,
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
      ..color = color.withOpacity(.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, trackPaint);

    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;

    final markerPositions = [0.0, 0.33, 0.67, 1.0];
    final markerPaint = Paint()
      ..color = color.withOpacity(.45)
      ..style = PaintingStyle.fill;

    for (final pos in markerPositions) {
      final tan = metrics.first.getTangentForOffset(metrics.first.length * pos);
      if (tan != null) {
        final p = tan.position;
        canvas.drawCircle(p, 3, markerPaint);
      }
    }

    final metric = metrics.first;
    final to = (metric.length * percent.clamp(0.0, 1.0)).clamp(0.0, metric.length);

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

    final label = _getSugarLevelDisplayName(sugarLevel);
    final painter = TextPainter(
      text: TextSpan(
        text: label.isEmpty ? 'Sugar' : '$label sugar',
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

  String _getSugarLevelDisplayName(SugarLevel level) {
    switch (level) {
      case SugarLevel.none:
        return 'No';
      case SugarLevel.light:
        return 'Light';
      case SugarLevel.medium:
        return 'Medium';
      case SugarLevel.high:
        return 'High';
    }
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

















