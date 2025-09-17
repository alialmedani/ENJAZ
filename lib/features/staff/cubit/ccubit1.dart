// lib/features/staff/staff_module.dart
import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/app_padding/app_padding.dart';
import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';

/// ===============================
/// Models
/// ===============================
enum ScheduleType { none, scheduled }

enum StaffOrderStatus { pending, inProgress, ready, delivered }

class OrderNote {
  final String author;
  final String text;
  final DateTime time;
  OrderNote({required this.author, required this.text, required this.time});
}

class StaffOrder {
  final String id;
  final String itemName;
  final String size;
  final int quantity;
  final int sugar; // spoons
  final int milkPct; // 0..100
  final List<String> addons;
  final String? customerNote;

  final int floor;
  final int office;

  StaffOrderStatus status;
  final ScheduleType scheduleType;
  final DateTime createdAt;
  final DateTime? scheduledAt;
  final int slaMinutes;

  String? assignee; // employee name
  final List<OrderNote> notes;

  StaffOrder({
    required this.id,
    required this.itemName,
    required this.size,
    required this.quantity,
    required this.sugar,
    required this.milkPct,
    required this.addons,
    this.customerNote,
    required this.floor,
    required this.office,
    required this.status,
    required this.scheduleType,
    required this.createdAt,
    required this.scheduledAt,
    required this.slaMinutes,
    this.assignee,
    List<OrderNote>? notes,
  }) : notes = notes ?? [];

  bool get mine => (assignee ?? '').isNotEmpty;
  DateTime get dueAt => createdAt.add(Duration(minutes: slaMinutes));
}

/// ===============================
/// Cubit (Mock data + actions)
/// ===============================
class StaffOrdersState {
  final List<StaffOrder> all;
  final bool loading;
  final String? error;

  const StaffOrdersState({
    required this.all,
    required this.loading,
    this.error,
  });

  StaffOrdersState copyWith({
    List<StaffOrder>? all,
    bool? loading,
    String? error,
  }) => StaffOrdersState(
    all: all ?? this.all,
    loading: loading ?? this.loading,
    error: error,
  );
}

class StaffOrdersCubit extends Cubit<StaffOrdersState> {
  StaffOrdersCubit() : super(const StaffOrdersState(all: [], loading: true)) {
    refresh();
  }

  Future<void> refresh() async {
    emit(state.copyWith(loading: true, error: null));
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock seed
    final now = DateTime.now();
    final data = <StaffOrder>[
      StaffOrder(
        id: 'ORD-1001',
        itemName: 'Cappuccino',
        size: 'M',
        quantity: 1,
        sugar: 1,
        milkPct: 50,
        addons: ['Vanilla'],
        customerNote: 'Extra hot please',
        floor: 2,
        office: 5,
        status: StaffOrderStatus.pending,
        scheduleType: ScheduleType.none,
        createdAt: now.subtract(const Duration(minutes: 3)),
        scheduledAt: null,
        slaMinutes: 12,
      ),
      StaffOrder(
        id: 'ORD-1002',
        itemName: 'Latte',
        size: 'L',
        quantity: 2,
        sugar: 0,
        milkPct: 40,
        addons: [],
        customerNote: null,
        floor: 3,
        office: 1,
        status: StaffOrderStatus.inProgress,
        scheduleType: ScheduleType.none,
        createdAt: now.subtract(const Duration(minutes: 8)),
        scheduledAt: null,
        slaMinutes: 15,
        assignee: 'Me',
        notes: [
          OrderNote(
            author: 'Me',
            text: 'Started',
            time: now.subtract(const Duration(minutes: 7)),
          ),
        ],
      ),
      StaffOrder(
        id: 'ORD-1003',
        itemName: 'Americano',
        size: 'S',
        quantity: 1,
        sugar: 0,
        milkPct: 0,
        addons: ['Cinnamon'],
        customerNote: 'No milk',
        floor: 1,
        office: 2,
        status: StaffOrderStatus.ready,
        scheduleType: ScheduleType.none,
        createdAt: now.subtract(const Duration(minutes: 18)),
        scheduledAt: null,
        slaMinutes: 15,
        assignee: 'Me',
      ),
      StaffOrder(
        id: 'ORD-2001',
        itemName: 'Mocha',
        size: 'M',
        quantity: 1,
        sugar: 1,
        milkPct: 60,
        addons: [],
        customerNote: null,
        floor: 4,
        office: 3,
        status: StaffOrderStatus.pending,
        scheduleType: ScheduleType.scheduled,
        createdAt: now,
        scheduledAt: now.add(const Duration(minutes: 25)),
        slaMinutes: 10,
      ),
    ];
    emit(StaffOrdersState(all: data, loading: false));
  }

  void accept(StaffOrder o, {String assignee = 'Me'}) {
    o.status = StaffOrderStatus.inProgress;
    o.assignee = assignee;
    o.notes.add(
      OrderNote(author: assignee, text: 'Accepted', time: DateTime.now()),
    );
    emit(state.copyWith(all: List.of(state.all)));
  }

  void markReady(StaffOrder o) {
    o.status = StaffOrderStatus.ready;
    o.notes.add(
      OrderNote(
        author: o.assignee ?? 'Staff',
        text: 'Ready',
        time: DateTime.now(),
      ),
    );
    emit(state.copyWith(all: List.of(state.all)));
  }

  void markDelivered(StaffOrder o) {
    o.status = StaffOrderStatus.delivered;
    o.notes.add(
      OrderNote(
        author: o.assignee ?? 'Staff',
        text: 'Delivered',
        time: DateTime.now(),
      ),
    );
    emit(state.copyWith(all: List.of(state.all)));
  }

  void addNote(StaffOrder o, String author, String text) {
    if (text.trim().isEmpty) return;
    o.notes.add(
      OrderNote(author: author, text: text.trim(), time: DateTime.now()),
    );
    emit(state.copyWith(all: List.of(state.all)));
  }

  void assignToMe(StaffOrder o, {String me = 'Me'}) {
    o.assignee = me;
    o.notes.add(
      OrderNote(author: me, text: 'Assigned to me', time: DateTime.now()),
    );
    emit(state.copyWith(all: List.of(state.all)));
  }
}

/// ===============================
/// Reusable: FadeSlide + Segmented
/// ===============================
class FadeSlideIn extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final double dy;
  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 420),
    this.dy = 12,
  });

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn> {
  bool _show = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) setState(() => _show = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _show ? 1 : 0,
      duration: widget.duration,
      curve: Curves.easeOutCubic,
      child: AnimatedSlide(
        offset: _show ? Offset.zero : Offset(0, widget.dy / 100),
        duration: widget.duration,
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}

class SegmentedTabs extends StatelessWidget {
  final TabController controller;
  final List<String> tabs;
  const SegmentedTabs({
    super.key,
    required this.controller,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    const pillRadius = 8.0;
    return LayoutBuilder(
      builder: (context, c) {
        final pillWidth = (c.maxWidth - 12) / tabs.length;
        final anim = controller.animation ?? controller;
        return Container(
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFEFE4DE)),
          ),
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: anim,
                builder: (_, __) {
                  final v = (controller.index + controller.offset).clamp(
                    0.0,
                    (tabs.length - 1).toDouble(),
                  );
                  final left = 6 + (v * pillWidth);
                  return AnimatedPositioned(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    left: left,
                    top: 6,
                    width: pillWidth,
                    height: 32,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.xprimaryColor,
                        borderRadius: BorderRadius.circular(pillRadius),
                      ),
                    ),
                  );
                },
              ),
              Row(
                children: List.generate(tabs.length, (i) {
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => controller.animateTo(
                        i,
                        duration: const Duration(milliseconds: 260),
                        curve: Curves.easeOutCubic,
                      ),
                      child: AnimatedBuilder(
                        animation: controller.animation ?? controller,
                        builder: (_, __) {
                          final dist =
                              (controller.index + controller.offset) - i;
                          final t = (1.0 - dist.abs()).clamp(0.0, 1.0);
                          final color = Color.lerp(
                            AppColors.secondPrimery,
                            Colors.white,
                            t,
                          );
                          final fw = t > .5 ? FontWeight.w700 : FontWeight.w500;
                          return Center(
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 140),
                              style: TextStyle(
                                color: color,
                                fontSize: AppFontSize.size_14,
                                fontWeight: fw,
                              ),
                              child: Text(tabs[i]),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}

class StaffHeader extends StatelessWidget {
  final String title;
  final TabController controller;
  const StaffHeader({super.key, required this.title, required this.controller});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF6EDE7);
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          FadeSlideIn(
            delay: const Duration(milliseconds: 20),
            child: Container(
              height: 120,
              width: double.infinity,
              color: bg,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 12,
                left: 16,
                right: 16,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyle.getBoldStyle(
                        fontSize: AppFontSize.size_18,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: -18,
            child: FadeSlideIn(
              delay: const Duration(milliseconds: 120),
              child: Container(
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.06),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(6),
                child: SegmentedTabs(
                  controller: controller,
                  tabs: [
                    'tab_queue'.tr(),
                    'tab_scheduled'.tr(),
                    'tab_my_orders'.tr(),
                    'tab_profile'.tr(),
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

/// ===============================
/// Entry Screen (Staff Home with 4 tabs)
/// ===============================
class StaffHomeScreen extends StatefulWidget {
  const StaffHomeScreen({super.key});

  @override
  State<StaffHomeScreen> createState() => _StaffHomeScreenState();
}

class _StaffHomeScreenState extends State<StaffHomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StaffOrdersCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF6EDE7),
        body: Column(
          children: [
            StaffHeader(title: 'staff_title'.tr(), controller: _tabs),
            Expanded(
              child: TabBarView(
                controller: _tabs,
                children: const [
                  _QueueTab(),
                  _ScheduledTab(),
                  _MyOrdersTab(),
                  _StaffProfileTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ===============================
/// (3) Queue Tab
/// ===============================
class _QueueTab extends StatefulWidget {
  const _QueueTab();

  @override
  State<_QueueTab> createState() => _QueueTabState();
}

class _QueueTabState extends State<_QueueTab> {
  String _search = '';
  int? _floorFilter;
  int? _officeFilter;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StaffOrdersCubit, StaffOrdersState>(
      builder: (context, st) {
        final items = st.all.where(
          (o) =>
              o.scheduleType == ScheduleType.none &&
              (o.status == StaffOrderStatus.pending ||
                  o.status == StaffOrderStatus.inProgress),
        );

        var list = items
            .where(
              (o) =>
                  _search.isEmpty ||
                  o.itemName.toLowerCase().contains(_search.toLowerCase()) ||
                  o.id.toLowerCase().contains(_search.toLowerCase()),
            )
            .toList();

        if (_floorFilter != null)
          list = list.where((o) => o.floor == _floorFilter).toList();
        if (_officeFilter != null)
          list = list.where((o) => o.office == _officeFilter).toList();

        return Column(
          children: [
            _QuickBar(
              placeholder: 'search_queue_placeholder'.tr(),
              onChanged: (v) => setState(() => _search = v),
              onRefresh: () => context.read<StaffOrdersCubit>().refresh(),
              filters: [
                _DropChip<int>(
                  label: 'filter_floor'.tr(),
                  values: const [1, 2, 3, 4, 5],
                  value: _floorFilter,
                  onChanged: (v) => setState(() => _floorFilter = v),
                ),
                _DropChip<int>(
                  label: 'filter_office'.tr(),
                  values: const [1, 2, 3, 4, 5, 6],
                  value: _officeFilter,
                  onChanged: (v) => setState(() => _officeFilter = v),
                ),
              ],
            ),
            Expanded(
              child: st.loading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.xprimaryColor,
                      ),
                    )
                  : list.isEmpty
                  ? _Empty(message: 'empty_queue'.tr())
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      physics: const BouncingScrollPhysics(),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        final o = list[i];
                        return FadeSlideIn(
                          delay: Duration(milliseconds: 60 * i),
                          child: _QueueCard(order: o),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _QueueCard extends StatelessWidget {
  final StaffOrder order;
  const _QueueCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StaffOrdersCubit>();
    final orange = AppColors.xprimaryColor;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              Expanded(
                child: Text(
                  'item_x_qty'.tr(
                    namedArgs: {
                      'name': order.itemName,
                      'size': order.size,
                      'qty': '${order.quantity}',
                    },
                  ),
                  style: AppTextStyle.getBoldStyle(
                    fontSize: AppFontSize.size_16,
                    color: AppColors.black23,
                  ),
                ),
              ),
              _StatusPill(status: order.status),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'floor_office'.tr(
              namedArgs: {
                'floor': '${order.floor}',
                'office': '${order.office}',
              },
            ),
            style: AppTextStyle.getRegularStyle(
              fontSize: AppFontSize.size_12,
              color: AppColors.secondPrimery,
            ),
          ),
          if ((order.customerNote ?? '').isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.sticky_note_2_outlined,
                  size: 16,
                  color: Colors.orange,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    order.customerNote!,
                    style: AppTextStyle.getRegularStyle(
                      fontSize: AppFontSize.size_12,
                      color: AppColors.black23,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 10),

          // SLA + actions
          Row(
            children: [
              _SlaCountdown(dueAt: order.dueAt),
              const Spacer(),
              if (order.status == StaffOrderStatus.pending)
                TextButton(
                  onPressed: () => cubit.accept(order),
                  child: Text('btn_accept'.tr()),
                ),
              if (order.status == StaffOrderStatus.inProgress)
                TextButton(
                  onPressed: () => cubit.markReady(order),
                  child: Text('btn_ready'.tr()),
                ),
              if (order.status == StaffOrderStatus.ready)
                TextButton(
                  onPressed: () => cubit.markDelivered(order),
                  child: Text('btn_delivered'.tr()),
                ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => StaffOrderDetailsScreen(order: order),
                    ),
                  );
                },
                icon: const Icon(Icons.description),
                label: Text('btn_details'.tr()),
                style: OutlinedButton.styleFrom(foregroundColor: orange),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ===============================
/// (4) Scheduled Tab
/// ===============================
class _ScheduledTab extends StatefulWidget {
  const _ScheduledTab();

  @override
  State<_ScheduledTab> createState() => _ScheduledTabState();
}

class _ScheduledTabState extends State<_ScheduledTab> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StaffOrdersCubit, StaffOrdersState>(
      builder: (context, st) {
        final now = DateTime.now();
        final list =
            st.all
                .where((o) => o.scheduleType == ScheduleType.scheduled)
                .where(
                  (o) =>
                      _search.isEmpty ||
                      o.itemName.toLowerCase().contains(
                        _search.toLowerCase(),
                      ) ||
                      o.id.toLowerCase().contains(_search.toLowerCase()),
                )
                .toList()
              ..sort(
                (a, b) =>
                    (a.scheduledAt ?? now).compareTo(b.scheduledAt ?? now),
              );

        return Column(
          children: [
            _QuickBar(
              placeholder: 'search_scheduled_placeholder'.tr(),
              onChanged: (v) => setState(() => _search = v),
              onRefresh: () => context.read<StaffOrdersCubit>().refresh(),
            ),
            Expanded(
              child: st.loading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.xprimaryColor,
                      ),
                    )
                  : list.isEmpty
                  ? _Empty(message: 'empty_scheduled'.tr())
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      physics: const BouncingScrollPhysics(),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        final o = list[i];
                        final minutesLeft = o.scheduledAt == null
                            ? null
                            : o.scheduledAt!.difference(now).inMinutes;
                        final showWarn =
                            minutesLeft != null &&
                            minutesLeft <= 10 &&
                            minutesLeft >= 0;
                        return FadeSlideIn(
                          delay: Duration(milliseconds: 60 * i),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.06),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'item_x_qty'.tr(
                                          namedArgs: {
                                            'name': o.itemName,
                                            'size': o.size,
                                            'qty': '${o.quantity}',
                                          },
                                        ),
                                        style: AppTextStyle.getBoldStyle(
                                          fontSize: AppFontSize.size_16,
                                          color: AppColors.black23,
                                        ),
                                      ),
                                    ),
                                    _StatusPill(
                                      status: o.status,
                                      scheduled: true,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'scheduled_at'.tr(
                                    namedArgs: {
                                      'time': _fmtDateTime(o.scheduledAt),
                                    },
                                  ),
                                  style: AppTextStyle.getRegularStyle(
                                    fontSize: AppFontSize.size_12,
                                    color: AppColors.secondPrimery,
                                  ),
                                ),
                                Text(
                                  'floor_office'.tr(
                                    namedArgs: {
                                      'floor': '${o.floor}',
                                      'office': '${o.office}',
                                    },
                                  ),
                                  style: AppTextStyle.getRegularStyle(
                                    fontSize: AppFontSize.size_12,
                                    color: AppColors.secondPrimery,
                                  ),
                                ),
                                if (showWarn) ...[
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.notifications_active,
                                        color: Colors.orange,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'scheduled_in_min'.tr(
                                          namedArgs: {
                                            'min': '${minutesLeft!.abs()}',
                                          },
                                        ),
                                        style: AppTextStyle.getBoldStyle(
                                          fontSize: AppFontSize.size_12,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    if (o.status == StaffOrderStatus.pending)
                                      TextButton(
                                        onPressed: () => context
                                            .read<StaffOrdersCubit>()
                                            .accept(o),
                                        child: Text('btn_accept'.tr()),
                                      ),
                                    if (o.status == StaffOrderStatus.inProgress)
                                      TextButton(
                                        onPressed: () => context
                                            .read<StaffOrdersCubit>()
                                            .markReady(o),
                                        child: Text('btn_ready'.tr()),
                                      ),
                                    if (o.status == StaffOrderStatus.ready)
                                      TextButton(
                                        onPressed: () => context
                                            .read<StaffOrdersCubit>()
                                            .markDelivered(o),
                                        child: Text('btn_delivered'.tr()),
                                      ),
                                    const Spacer(),
                                    OutlinedButton.icon(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                StaffOrderDetailsScreen(
                                                  order: o,
                                                ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.description),
                                      label: Text('btn_details'.tr()),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

/// ===============================
/// (5) My Orders Tab
/// ===============================
class _MyOrdersTab extends StatefulWidget {
  const _MyOrdersTab();

  @override
  State<_MyOrdersTab> createState() => _MyOrdersTabState();
}

class _MyOrdersTabState extends State<_MyOrdersTab> {
  String _search = '';
  final Set<StaffOrderStatus> _status = {
    StaffOrderStatus.pending,
    StaffOrderStatus.inProgress,
    StaffOrderStatus.ready,
    StaffOrderStatus.delivered,
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StaffOrdersCubit, StaffOrdersState>(
      builder: (context, st) {
        var list = st.all.where((o) => (o.assignee == 'Me')).toList();

        list = list.where((o) => _status.contains(o.status)).toList();
        if (_search.isNotEmpty) {
          list = list
              .where(
                (o) =>
                    o.itemName.toLowerCase().contains(_search.toLowerCase()) ||
                    o.id.toLowerCase().contains(_search.toLowerCase()),
              )
              .toList();
        }

        return Column(
          children: [
            _QuickBar(
              placeholder: 'search_my_orders_placeholder'.tr(),
              onChanged: (v) => setState(() => _search = v),
              onRefresh: () => context.read<StaffOrdersCubit>().refresh(),
              extra: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: StaffOrderStatus.values.map((s) {
                    final active = _status.contains(s);
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        selected: active,
                        label: Text(_statusKey(s).tr()),
                        onSelected: (_) {
                          setState(() {
                            if (active) {
                              _status.remove(s);
                            } else {
                              _status.add(s);
                            }
                          });
                        },
                        selectedColor: AppColors.xprimaryColor,
                        labelStyle: TextStyle(
                          color: active ? Colors.white : AppColors.black,
                          fontWeight: active
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              child: st.loading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.xprimaryColor,
                      ),
                    )
                  : list.isEmpty
                  ? _Empty(message: 'empty_my_orders'.tr())
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      physics: const BouncingScrollPhysics(),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        final o = list[i];
                        return FadeSlideIn(
                          delay: Duration(milliseconds: 60 * i),
                          child: _MyOrderCard(order: o),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _MyOrderCard extends StatelessWidget {
  final StaffOrder order;
  const _MyOrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StaffOrdersCubit>();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'item_x_qty'.tr(
                    namedArgs: {
                      'name': order.itemName,
                      'size': order.size,
                      'qty': '${order.quantity}',
                    },
                  ),
                  style: AppTextStyle.getBoldStyle(
                    fontSize: AppFontSize.size_16,
                    color: AppColors.black23,
                  ),
                ),
              ),
              _StatusPill(status: order.status),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'floor_office'.tr(
              namedArgs: {
                'floor': '${order.floor}',
                'office': '${order.office}',
              },
            ),
            style: AppTextStyle.getRegularStyle(
              fontSize: AppFontSize.size_12,
              color: AppColors.secondPrimery,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              if (order.status == StaffOrderStatus.pending)
                TextButton(
                  onPressed: () => cubit.accept(order),
                  child: Text('btn_accept'.tr()),
                ),
              if (order.status == StaffOrderStatus.inProgress)
                TextButton(
                  onPressed: () => cubit.markReady(order),
                  child: Text('btn_ready'.tr()),
                ),
              if (order.status == StaffOrderStatus.ready)
                TextButton(
                  onPressed: () => cubit.markDelivered(order),
                  child: Text('btn_delivered'.tr()),
                ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => StaffOrderDetailsScreen(order: order),
                  ),
                ),
                icon: const Icon(Icons.description),
                label: Text('btn_details'.tr()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ===============================
/// (6) Order Details — Polished UI
/// ===============================
class StaffOrderDetailsScreen extends StatefulWidget {
  final StaffOrder order;
  const StaffOrderDetailsScreen({super.key, required this.order});

  @override
  State<StaffOrderDetailsScreen> createState() =>
      _StaffOrderDetailsScreenState();
}

class _StaffOrderDetailsScreenState extends State<StaffOrderDetailsScreen> {
  final _ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final o = widget.order;
    final cubit = context.read<StaffOrdersCubit>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6EDE7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.xprimaryColor,
        title: Text(
          'order_id'.tr(namedArgs: {'id': o.id}),
          style: AppTextStyle.getBoldStyle(
            fontSize: AppFontSize.size_16,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          // Header summary
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFE7E4B), Color(0xFFFFB56B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _chip(
                      text: _statusLabel(context, o.status),
                      icon: Icons.flag,
                    ),
                    if (o.scheduleType == ScheduleType.scheduled &&
                        o.scheduledAt != null)
                      _chip(
                        text: 'scheduled_at'.tr(
                          namedArgs: {'time': _fmtDateTime(o.scheduledAt)},
                        ),
                        icon: Icons.event,
                      ),
                    _chip(
                      text: 'floor_office'.tr(
                        namedArgs: {
                          'floor': '${o.floor}',
                          'office': '${o.office}',
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'item_x_qty'.tr(
                    namedArgs: {
                      'name': o.itemName,
                      'size': o.size,
                      'qty': '${o.quantity}',
                    },
                  ),
                  style: AppTextStyle.getBoldStyle(
                    fontSize: AppFontSize.size_18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                _SlaCountdown.inHeader(dueAt: o.dueAt),
              ],
            ),
          ),

          // Body content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _Section(
                  title: 'section_order_info'.tr(),
                  child: Column(
                    children: [
                      _InfoTile(
                        title: 'info_sugar'.tr(),
                        value: 'sugar_spoons'.tr(
                          namedArgs: {'n': '${o.sugar}'},
                        ),
                      ),
                      _InfoTile(
                        title: 'info_milk'.tr(),
                        value: '${o.milkPct}%',
                      ),
                      _InfoTile(
                        title: 'info_addons'.tr(),
                        value: o.addons.isEmpty ? '-' : o.addons.join(', '),
                      ),
                      _InfoTile(
                        title: 'info_customer_note'.tr(),
                        value: (o.customerNote ?? '-'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _Section(
                  title: 'section_assignment'.tr(),
                  child: Column(
                    children: [
                      _InfoTile(
                        title: 'info_status'.tr(),
                        value: _statusLabel(context, o.status),
                      ),
                      _InfoTile(
                        title: 'info_assignee'.tr(),
                        value: (o.assignee ?? '-'),
                      ),
                      if (o.scheduleType == ScheduleType.scheduled)
                        _InfoTile(
                          title: 'info_scheduled_at'.tr(),
                          value: _fmtDateTime(o.scheduledAt),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _Section(
                  title: 'section_notes'.tr(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (o.notes.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            'empty_notes'.tr(),
                            style: AppTextStyle.getRegularStyle(
                              fontSize: AppFontSize.size_12,
                              color: AppColors.secondPrimery,
                            ),
                          ),
                        )
                      else
                        ...o.notes.reversed.map((n) => _NoteTile(n)).toList(),
                      const SizedBox(height: 8),
                      _NoteComposer(
                        controller: _ctrl,
                        hint: 'hint_add_note'.tr(),
                        onSend: () {
                          final txt = _ctrl.text;
                          _ctrl.clear();
                          cubit.addNote(o, 'Me', txt);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Actions
                Row(
                  children: [
                    if (o.assignee == null)
                      OutlinedButton.icon(
                        onPressed: () => setState(() => cubit.assignToMe(o)),
                        icon: const Icon(Icons.assignment_ind_outlined),
                        label: Text('btn_assign_to_me'.tr()),
                      ),
                    const Spacer(),
                    if (o.status == StaffOrderStatus.pending)
                      ElevatedButton(
                        onPressed: () => setState(() => cubit.accept(o)),
                        child: Text('btn_accept'.tr()),
                      ),
                    if (o.status == StaffOrderStatus.inProgress)
                      ElevatedButton(
                        onPressed: () => setState(() => cubit.markReady(o)),
                        child: Text('btn_ready'.tr()),
                      ),
                    if (o.status == StaffOrderStatus.ready)
                      ElevatedButton(
                        onPressed: () => setState(() => cubit.markDelivered(o)),
                        child: Text('btn_delivered'.tr()),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyle.getBoldStyle(
              fontSize: AppFontSize.size_14,
              color: AppColors.black23,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

Widget _chip({required String text, IconData? icon}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(.18),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.white.withOpacity(.35)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
        ],
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;
  const _InfoTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEFE4DE)),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: AppTextStyle.getRegularStyle(
              fontSize: AppFontSize.size_12,
              color: AppColors.secondPrimery,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTextStyle.getBoldStyle(
              fontSize: AppFontSize.size_12,
              color: AppColors.black23,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoteComposer extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final String hint;
  const _NoteComposer({
    required this.controller,
    required this.onSend,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEFE4DE)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(onPressed: onSend, icon: const Icon(Icons.send)),
        ],
      ),
    );
  }
}

class _NoteTile extends StatelessWidget {
  final OrderNote n;
  const _NoteTile(this.n);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.comment, size: 18, color: Colors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      n.author,
                      style: AppTextStyle.getBoldStyle(
                        fontSize: AppFontSize.size_12,
                        color: AppColors.black23,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _fmtDateTime(n.time),
                      style: AppTextStyle.getRegularStyle(
                        fontSize: AppFontSize.size_10,
                        color: AppColors.secondPrimery,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  n.text,
                  style: AppTextStyle.getRegularStyle(
                    fontSize: AppFontSize.size_12,
                    color: AppColors.black,
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

/// ===============================
/// (7) Staff Profile (light)
/// ===============================
class _StaffProfileTab extends StatelessWidget {
  const _StaffProfileTab();

  @override
  Widget build(BuildContext context) {
    // Mock small summary
    final totalOrders = context.select<StaffOrdersCubit, int>(
      (c) => c.state.all.length,
    );
    final most = context.select<StaffOrdersCubit, String>(
      (dynamic c) {
            final map = <String, int>{};
            for (final o in c.state.all) {
              map[o.itemName] = (map[o.itemName] ?? 0) + 1;
            }
            if (map.isEmpty) return '-';
            final top = map.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));
            return top.first.key;
          }
          as String Function(StaffOrdersCubit value),
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      children: [
        FadeSlideIn(
          delay: const Duration(milliseconds: 80),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.06),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                const CircleAvatar(radius: 28, child: Icon(Icons.person)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'profile_me_label'.tr(),
                        style: AppTextStyle.getBoldStyle(
                          fontSize: AppFontSize.size_16,
                          color: AppColors.black23,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'profile_meta'.tr(
                          namedArgs: {'floor': '2', 'office': '5'},
                        ),
                        style: AppTextStyle.getRegularStyle(
                          fontSize: AppFontSize.size_12,
                          color: AppColors.secondPrimery,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        FadeSlideIn(
          delay: const Duration(milliseconds: 160),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.06),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                _StatBox(
                  title: 'stat_total_orders'.tr(),
                  value: '$totalOrders',
                ),
                _StatBox(title: 'stat_most_drink'.tr(), value: most),
                _StatBox(
                  title: 'stat_ready_now'.tr(),
                  value:
                      '${context.read<StaffOrdersCubit>().state.all.where((o) => o.status == StaffOrderStatus.ready).length}',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        FadeSlideIn(
          delay: const Duration(milliseconds: 240),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.06),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'section_settings'.tr(),
                  style: AppTextStyle.getBoldStyle(
                    fontSize: AppFontSize.size_14,
                    color: AppColors.black23,
                  ),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  value: true,
                  onChanged: (_) {},
                  title: Text('settings_notifications'.tr()),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _OutlinedText(
                        'settings_default_floor'.tr(namedArgs: {'n': '2'}),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _OutlinedText(
                        'settings_default_office'.tr(namedArgs: {'n': '5'}),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.save),
                        label: Text('btn_save'.tr()),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.picture_as_pdf),
                        label: Text('btn_export_pdf_later'.tr()),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String title;
  final String value;
  const _StatBox({required this.title, required this.value});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEFE4DE)),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: AppTextStyle.getRegularStyle(
                fontSize: AppFontSize.size_12,
                color: AppColors.secondPrimery,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: AppTextStyle.getBoldStyle(
                fontSize: AppFontSize.size_14,
                color: AppColors.black23,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutlinedText extends StatelessWidget {
  final String text;
  const _OutlinedText(this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEFE4DE)),
      ),
      child: Text(text),
    );
  }
}

/// ===============================
/// (8) Quick Filters & Actions bar
/// ===============================
class _QuickBar extends StatelessWidget {
  final String placeholder;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onRefresh;
  final List<Widget>? filters;
  final Widget? extra;
  const _QuickBar({
    required this.placeholder,
    this.onChanged,
    this.onRefresh,
    this.filters,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 28),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFEFE4DE)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.search),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          onChanged: onChanged,
                          decoration: InputDecoration(
                            hintText: placeholder,
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(onPressed: onRefresh, icon: const Icon(Icons.refresh)),
            ],
          ),
        ),
        if (filters != null || extra != null) ...[
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...(filters ?? []),
                  if (extra != null) ...[
                    if (filters != null && filters!.isNotEmpty)
                      const SizedBox(width: 10),
                    extra!,
                  ],
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _DropChip<T> extends StatelessWidget {
  final String label;
  final List<T> values;
  final T? value;
  final ValueChanged<T?> onChanged;

  const _DropChip({
    required this.label,
    required this.values,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEFE4DE)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T?>(
          // لاحظ النوع صار T? بدل T
          hint: Text(label),
          value: value, // النوع T?
          isDense: true,
          onChanged: onChanged, // ValueChanged<T?>
          items: <DropdownMenuItem<T?>>[
            DropdownMenuItem<T?>(value: null, child: Text('filter_all'.tr())),
            ...values.map(
              (e) => DropdownMenuItem<T?>(value: e, child: Text('$e')),
            ),
          ],
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  final String message;
  const _Empty({required this.message});
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Text(
        message,
        style: AppTextStyle.getRegularStyle(
          fontSize: AppFontSize.size_14,
          color: AppColors.secondPrimery,
        ),
      ),
    ),
  );
}

class _StatusPill extends StatelessWidget {
  final StaffOrderStatus status;
  final bool scheduled;
  const _StatusPill({required this.status, this.scheduled = false});

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
    final key = scheduled ? _scheduledStatusKey(status) : _statusKey(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        key.tr(),
        style: AppTextStyle.getBoldStyle(
          fontSize: AppFontSize.size_12,
          color: fg,
        ),
      ),
    );
  }
}

/// SLA countdown widget (updates each second)
class _SlaCountdown extends StatefulWidget {
  final DateTime dueAt;
  final bool header;
  const _SlaCountdown({required this.dueAt}) : header = false;
  const _SlaCountdown.inHeader({required this.dueAt}) : header = true;

  @override
  State<_SlaCountdown> createState() => _SlaCountdownState();
}

class _SlaCountdownState extends State<_SlaCountdown> {
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
          style: AppTextStyle.getBoldStyle(
            fontSize: AppFontSize.size_12,
            color: color,
          ),
        ),
      ],
    );
  }
}

/// ===============================
/// Helpers (labels / formatting)
/// ===============================
String _fmtDateTime(DateTime? t) {
  if (t == null) return '-';
  final f = DateFormat('yyyy-MM-dd HH:mm');
  return f.format(t);
}

String _statusKey(StaffOrderStatus s) {
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
}

String _scheduledStatusKey(StaffOrderStatus s) {
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

String _statusLabel(BuildContext context, StaffOrderStatus s) =>
    _statusKey(s).tr();

/// ===============================
/// (8) END
/// ===============================
