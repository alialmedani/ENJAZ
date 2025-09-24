import 'dart:ui';
import 'package:enjaz/features/officeboy/cubit/cubit/office_boy_cubit.dart';
import 'package:enjaz/features/officeboy/data/usecase/get_order_usecase.dart';
import 'package:enjaz/features/officeboy/data/usecase/status_order_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:enjaz/core/boilerplate/pagination/widgets/pagination_list.dart';
import 'package:enjaz/core/boilerplate/pagination/cubits/pagination_cubit.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';
import 'package:enjaz/core/constant/app_padding/app_padding.dart';

import 'package:enjaz/features/officeboy/data/model/officeboy_model.dart';

class OfficeBoyOrdersScreen extends StatefulWidget {
  const OfficeBoyOrdersScreen({super.key});

  @override
  State<OfficeBoyOrdersScreen> createState() => _OfficeBoyOrdersScreenState();
}

class _OfficeBoyOrdersScreenState extends State<OfficeBoyOrdersScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final Map<int, PaginationCubit?> _tabPaginationCubits = {
    0: null,
    1: null,
    4: null,
    5: null,
  };

  final List<_StatusTab> _tabs = const [
    _StatusTab(label: 'Pending', status: 0, icon: Icons.timer_outlined),
    _StatusTab(
      label: 'In-Progress',
      status: 1,
      icon: Icons.run_circle_outlined,
    ),
    _StatusTab(label: 'Completed', status: 4, icon: Icons.check_circle_outline),
    _StatusTab(label: 'Cancelled', status: 5, icon: Icons.cancel_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildStatusTab({required int status, required String emptyTitle}) {
    return Builder(
      builder: (context) {
        final officeBoyCubit = context.read<OfficeBoyCubit>();
        return PaginationList<OfficeBoyModel>(
          key: PageStorageKey('officeboy-status-$status'),
          physics: const BouncingScrollPhysics(),
          withRefresh: false,
          onCubitCreated: (PaginationCubit cubit) {
            _tabPaginationCubits[status] = cubit;
            officeBoyCubit.drinkCubit = cubit;
          },
          repositoryCallBack: (data) {
            officeBoyCubit.getOrderOfficeBoyParams = GetOrderOfficeBoyParams(
              request: data,
              status: status,
            );
            return officeBoyCubit.fetchAllOrderServies(data);
          },
          listBuilder: (List<OfficeBoyModel> apiList) {
            final List<Items> orders = <Items>[
              for (final page in apiList) ...page.items ?? const [],
            ];

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                if (orders.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(AppPaddingSize.padding_16),
                      child: _FancyEmptyState(
                        title: emptyTitle,
                        subtitle: 'لا توجد نتائج لعرضها حالياً.',
                        ctaLabel: 'حسناً',
                        onCta: () {},
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPaddingSize.padding_16,
                      vertical: AppPaddingSize.padding_8,
                    ),
                    sliver: SliverList.separated(
                      itemCount: orders.length,
                      itemBuilder: (_, i) => _ShowUp(
                        delayMs: 20 * (i % 12),
                        child: _OrderCard(order: orders[i]),
                      ),
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppPaddingSize.padding_10),
                    ),
                  ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppFontSize.size_60),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.xbackgroundColor3,

      body: Stack(
        children: [
          const _FancyBackdrop(),
          Column(
            children: [
              SafeArea(
                child: Text(
                  'Office Boy Orders',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.orange.withValues(alpha: 0.78),
                    fontSize: AppFontSize.size_18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _AnimatedTabs(controller: _tabController, tabs: _tabs),
              const SizedBox(height: 8),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: const BouncingScrollPhysics(),
                  children: _tabs
                      .map(
                        (t) => _buildStatusTab(
                          status: t.status,
                          emptyTitle: 'لا توجد طلبات لهذه الحالة',
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.xprimaryColor,
        onPressed: () {
          final currentStatus = _tabs[_tabController.index].status;
          final cubit = _tabPaginationCubits[currentStatus];
          cubit; // تُركت لميكانيزمك الخاص
        },
        label: const Text(
          'تحديث هذه الحالة',
          style: TextStyle(color: AppColors.white),
        ),
        icon: const Icon(Icons.refresh, color: AppColors.white),
      ),
    );
  }
}

class _StatusTab {
  final String label;
  final int status;
  final IconData icon;
  const _StatusTab({
    required this.label,
    required this.status,
    required this.icon,
  });
}

class _AnimatedTabs extends StatelessWidget {
  final TabController controller;
  final List<_StatusTab> tabs;
  const _AnimatedTabs({required this.controller, required this.tabs});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppPaddingSize.padding_12,
        AppPaddingSize.padding_12,
        AppPaddingSize.padding_12,
        AppPaddingSize.padding_6,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .65),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.greyE5.withValues(alpha: .8)),
      ),
      child: TabBar(
        controller: controller,
        isScrollable: true,
        labelPadding: const EdgeInsets.symmetric(horizontal: 14),
        indicator: BoxDecoration(
          color: AppColors.xprimaryColor.withValues(alpha: .12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.xprimaryColor.withValues(alpha: .35),
          ),
        ),
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: AppColors.black,
        unselectedLabelColor: AppColors.grey89,
        tabs: [
          for (final t in tabs)
            Tab(
              height: 40,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(t.icon, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        t.label,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SlidingIndicator extends StatefulWidget {
  final TabController controller;
  final int itemCount;
  const _SlidingIndicator({required this.controller, required this.itemCount});

  @override
  State<_SlidingIndicator> createState() => _SlidingIndicatorState();
}

class _SlidingIndicatorState extends State<_SlidingIndicator> {
  double _animIndex = 0;

  @override
  void initState() {
    super.initState();
    _animIndex = widget.controller.index.toDouble();
    widget.controller.addListener(_onTick);
  }

  void _onTick() {
    setState(() {
      _animIndex =
          widget.controller.animation?.value ??
          widget.controller.index.toDouble();
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTick);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.itemCount.clamp(1, 99);
    final widthFactor = 1 / count;
    final clamped = _animIndex.clamp(0, (count - 1).toDouble());
    final x = -1 + widthFactor + (2 * widthFactor * clamped);

    // ✅ AnimatedAlign داخل Positioned.fill -> لازم يكون ابن مباشر للـ Stack (وهو كذلك)
    return Positioned.fill(
      top: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          alignment: Alignment(x.toDouble(), 0),
          child: FractionallySizedBox(
            widthFactor: widthFactor,
            heightFactor: 1,
            child: Container(
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.xprimaryColor.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.xprimaryColor.withValues(alpha: .35),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// خلفية زخرفية بسيطة
class _FancyBackdrop extends StatelessWidget {
  const _FancyBackdrop();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BackdropPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _BackdropPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final g1 = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFEAF2FF), Color(0xFFFFFFFF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, g1);

    final circle = Paint()
      ..color = const Color(0xFFCCE2FF).withValues(alpha: .35);
    canvas.drawCircle(Offset(size.width * .8, 120), 90, circle);
    canvas.drawCircle(Offset(size.width * .2, size.height * .35), 70, circle);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// حركة ظهور لطيفة
class _ShowUp extends StatefulWidget {
  final Widget child;
  final int delayMs;
  const _ShowUp({required this.child, this.delayMs = 0});

  @override
  State<_ShowUp> createState() => _ShowUpState();
}

class _ShowUpState extends State<_ShowUp> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.delayMs), () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 260),
      opacity: _visible ? 1 : 0,
      curve: Curves.easeOut,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
        offset: _visible ? Offset.zero : const Offset(0, .08),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
          scale: _visible ? 1 : .97,
          child: widget.child,
        ),
      ),
    );
  }
}

class _FancyEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final String ctaLabel;
  final VoidCallback onCta;
  const _FancyEmptyState({
    required this.title,
    required this.subtitle,
    required this.ctaLabel,
    required this.onCta,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .06),
                    blurRadius: 16,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.inbox_outlined,
                size: 36,
                color: AppColors.grey89,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.size_16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.grey89,
                fontSize: AppFontSize.size_13,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onCta,
              icon: const Icon(Icons.refresh),
              label: Text(ctaLabel),
            ),
          ],
        ),
      ),
    );
  }
}

/// ↓↓↓ الكروت والأزرار نفس السابق (ما لمست الـ core)
class _OrderCard extends StatelessWidget {
  final Items order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final int? status = order.status;

    final String? customerName = order.customerUser?.name;
    final String? floorName = order.floorName;
    final String? officeName = order.officeName;
    final String? createdAt = order.creationTime;

    final List<OrderItems> items = order.orderItems ?? const [];

    return _PressableScale(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppFontSize.size_14),
          border: Border.all(color: AppColors.greyE5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(AppPaddingSize.padding_14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: _StatusPill(status: status ?? -1),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 18,
                  color: AppColors.black,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    (customerName ?? '—'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: AppFontSize.size_15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.apartment_outlined,
                  size: 18,
                  color: AppColors.black,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    [
                      if (floorName != null) floorName,
                      if (officeName != null) officeName,
                    ].join(' • '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: AppFontSize.size_13,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ],
            ),
            if (createdAt != null) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.schedule, size: 18, color: AppColors.grey89),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      createdAt,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: AppFontSize.size_12,
                        color: AppColors.grey89,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            _OrderItemsList(items: items),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) => Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _ActionBtn(
                    icon: Icons.check_circle_outline,
                    label: 'Accept',
                    color: Colors.green,
                    onTap: (status == 1 || status == 4 || status == 5)
                        ? null
                        : () => _changeStatus(context, order, 1),
                  ),
                  _ActionBtn(
                    icon: Icons.cancel_outlined,
                    label: 'Cancel',
                    color: Colors.red,
                    onTap: (status == 4 || status == 5)
                        ? null
                        : () => _changeStatus(context, order, 5),
                  ),
                  SizedBox(
                    width: constraints.maxWidth > 360
                        ? constraints.maxWidth - 260
                        : 0,
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 220),
                    child: TextButton.icon(
                      onPressed: () => _showChangeStatusSheet(context, order),
                      icon: const Icon(Icons.swap_horiz_rounded),
                      label: const Text(
                        'تغيير الحالة',
                        overflow: TextOverflow.ellipsis,
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.xprimaryColor,
                      ),
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

  Future<void> _changeStatus(
    BuildContext context,
    Items order,
    int newStatus,
  ) async {
    final cubit = context.read<OfficeBoyCubit>();
    cubit.updateOrderStatusParams = UpdateOrderStatusParams(
      orderId: order.id ?? '',
      status: newStatus,
    );
    await cubit.updateOrderStatusBool();
    cubit.drinkCubit;
  }
}

class _PressableScale extends StatefulWidget {
  final Widget child;
  const _PressableScale({required this.child});

  @override
  State<_PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<_PressableScale> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => setState(() => _down = true),
      onPointerUp: (_) => setState(() => _down = false),
      onPointerCancel: (_) => setState(() => _down = false),
      child: AnimatedScale(
        scale: _down ? 0.98 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 96),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: disabled ? Colors.grey.shade200 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: disabled
                  ? Colors.grey.shade300
                  : color.withValues(alpha: .5),
            ),
            boxShadow: disabled
                ? null
                : [
                    BoxShadow(
                      color: color.withValues(alpha: .08),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: disabled ? Colors.grey : color),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: disabled ? Colors.grey : color,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderItemsList extends StatelessWidget {
  final List<OrderItems> items;
  const _OrderItemsList({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppPaddingSize.padding_12),
        decoration: BoxDecoration(
          color: AppColors.whiteF3,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'لا توجد عناصر في هذا الطلب',
          style: TextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.size_13,
          ),
        ),
      );
    }

    return Column(
      children: items.map((e) {
        final String? name = e.drink?.name;
        final int? qty = e.quantity;
        final int? sugar = e.sugarLevel;
        final String? notes = e.bengaliNotes;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(AppPaddingSize.padding_12),
          decoration: BoxDecoration(
            color: AppColors.whiteF3,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.local_cafe, color: AppColors.black),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (name != null)
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: AppFontSize.size_14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.black,
                        ),
                      ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        if (qty != null) _MiniChip(label: 'الكمية: $qty'),
                        if (sugar != null) _MiniChip(label: 'سكر: $sugar'),
                        if (notes != null && notes.isNotEmpty)
                          _MiniChip(label: 'ملاحظة: $notes'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final String label;
  const _MiniChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPaddingSize.padding_8,
        vertical: AppPaddingSize.padding_4,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.greyE5),
      ),
      child: Text(
        label,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: AppFontSize.size_12,
          color: AppColors.black,
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final int status;
  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final Color c = _statusColor(status);
    final String label = _statusLabel(status);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPaddingSize.padding_10,
        vertical: AppPaddingSize.padding_6,
      ),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: c),
          const SizedBox(width: 6),
          Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: c,
              fontSize: AppFontSize.size_12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  static Color _statusColor(int status) {
    switch (status) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.blue;
      case 4:
        return Colors.green;
      case 5:
        return Colors.red;
      default:
        return AppColors.greyA4;
    }
  }

  static String _statusLabel(int status) {
    switch (status) {
      case 0:
        return 'قيد الانتظار';
      case 1:
        return 'قيد التنفيذ';
      case 4:
        return 'مكتمل';
      case 5:
        return 'ملغي';
      default:
        return 'غير معروف';
    }
  }
}

void _showChangeStatusSheet(BuildContext context, Items order) {
  final List<int> allowed = [0, 1, 4, 5];
  int selected = order.status ?? 0;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => StatefulBuilder(
      builder: (context, setSt) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const Text(
              'تغيير حالة الطلب',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: AppFontSize.size_16,
                fontWeight: FontWeight.w800,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final s in allowed)
                  ChoiceChip(
                    label: Text(_StatusPill._statusLabel(s)),
                    selected: selected == s,
                    onSelected: (_) => setSt(() => selected = s),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.save_outlined),
              label: const Text('حفظ'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.xprimaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final cubit = context.read<OfficeBoyCubit>();
                cubit.updateOrderStatusParams = UpdateOrderStatusParams(
                  orderId: order.id ?? '',
                  status: selected,
                );
                await cubit.updateOrderStatusBool();
                cubit.drinkCubit;
                if (context.mounted) Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    ),
  );
}
