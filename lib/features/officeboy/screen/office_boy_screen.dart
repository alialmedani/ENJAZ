// lib/features/staff/screen/office_boy_home_root.dart
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:enjaz/core/constant/enum/enum.dart' as Core;
import 'package:enjaz/features/officeboy/screen/widget/3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';

import 'package:enjaz/core/boilerplate/pagination/widgets/pagination_list.dart';
import 'package:enjaz/core/boilerplate/pagination/models/get_list_request.dart';
import 'package:enjaz/core/results/result.dart';

import 'package:enjaz/features/officeboy/cubit/cubit/office_boy_cubit.dart';
import 'package:enjaz/features/officeboy/screen/widget/segmented_status_tabs.dart';
import 'package:enjaz/features/officeboy/data/model/officeboy_model.dart';
  
// ====== البروفايل (عندك جاهز) ======
 
class OfficeBoyHomeRoot extends StatefulWidget {
  const OfficeBoyHomeRoot({super.key});
  @override
  State<OfficeBoyHomeRoot> createState() => _OfficeBoyHomeRootState();
}

class _OfficeBoyHomeRootState extends State<OfficeBoyHomeRoot> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const _OrdersTabShell(), // تبويب الطلبات
      const ProfileScreenPro(
        // تبويب البروفايل
        name: 'Lolo',
        email: '09420733555@coffeeapp.local',
        role: 'Office Boy',
        avatarUrl: null, // أو لينك صورة
      ),
    ];

    return BlocProvider(
      create: (_) => OfficeBoyCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF6EDE7),
        body: SafeArea(
          child: IndexedStack(index: _index, children: pages),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          selectedItemColor: AppColors.xprimaryColor,
          unselectedItemColor: AppColors.secondPrimery,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.coffee_outlined),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
        floatingActionButton: _index == 0
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton.small(
                    heroTag: 'refresh',
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      // لو بدك ترفّرش الليست
                      // تقدر توصل للكيوبيت اللي جوّا OrdersTabShell لو عملته GlobalKey
                    },
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.refresh, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton(
                    heroTag: 'scan',
                    onPressed: () => HapticFeedback.selectionClick(),
                    backgroundColor: AppColors.xprimaryColor,
                    child: const Icon(Icons.qr_code_scanner),
                  ),
                ],
              )
            : null,
      ),
    );
  }
}

/// =============================================
///       تبويب الطلبات (شاشة Orders متقدمة)
/// =============================================
class _OrdersTabShell extends StatefulWidget {
  const _OrdersTabShell({super.key});
  @override
  State<_OrdersTabShell> createState() => _OrdersTabShellState();
}

class _OrdersTabShellState extends State<_OrdersTabShell>
    with TickerProviderStateMixin {
  late final TabController _segCtrl;

  // نفس القيم لحساب الطول وتمريرها للويجت
  late final List<OrderStatus> _orderForTabs;
  late final bool _showAll;
  late final bool _excludeDraft;

  String _search = '';
  String? _floorFilter;
  String? _officeFilter;
  OrderStatus? _selected;

  @override
  void initState() {
    super.initState();
    _orderForTabs = const [
      OrderStatus.submitted,
      OrderStatus.inPreparation,
      OrderStatus.canceled,
    ];
    _showAll = false;
    _excludeDraft = true;

    final count = requiredTabsCount(
      showAll: _showAll,
      excludeDraft: _excludeDraft,
      order: _orderForTabs,
    );
    _segCtrl = TabController(length: count, vsync: this);
  }

  @override
  void dispose() {
    _segCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        _HeaderCard(
          title: 'Coffee Queue',
          subtitle: DateFormat('EEE d MMM • HH:mm').format(DateTime.now()),
        ),
        const SizedBox(height: 8),

        // Tabs (Ultra) — نفس القيم للضمان
        SegmentedStatusTabsUltra(
          controller: _segCtrl,
          showAll: _showAll,
          excludeDraft: _excludeDraft,
          order: _orderForTabs,
          onChanged: (s) => setState(() => _selected = s),
        ),

        // Filters & Search
        _FiltersBar(onSearchChanged: (v) => setState(() => _search = v)),

        // Content
        Expanded(
          child: _OrdersTab(
            search: _search,
            floorFilter: _floorFilter,
            officeFilter: _officeFilter,
            selectedStatus: _selected,
            onFloorChanged: (v) => setState(() {
              _floorFilter = v;
              _officeFilter = null;
            }),
            onOfficeChanged: (v) => setState(() => _officeFilter = v),
          ),
        ),
      ],
    );
  }
}

/// ------------------ HEADER ------------------
class _HeaderCard extends StatelessWidget {
  final String title, subtitle;
  const _HeaderCard({required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.xprimaryColor.withOpacity(.16),
                      Colors.white.withOpacity(.85),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: const Color(0xFFEFE4DE)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.coffee_outlined, color: Colors.brown),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppTextStyle.getBoldStyle(
                              fontSize: AppFontSize.size_18,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: AppTextStyle.getRegularStyle(
                              fontSize: AppFontSize.size_12,
                              color: AppColors.secondPrimery,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _Bell(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bell extends StatefulWidget {
  @override
  State<_Bell> createState() => _BellState();
}

class _BellState extends State<_Bell> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (!_ctrl.isAnimating) _ctrl.forward(from: 0);
      },
      icon: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, child) {
          final t = _ctrl.value;
          final double dx = t < .2
              ? 8.0 * (t / .2)
              : (t < .6 ? 8.0 * (1 - ((t - .2) / .4)) : 0.0);
          return Transform.translate(offset: Offset(dx, 0), child: child);
        },
        child: const Icon(Icons.notifications_outlined, color: Colors.black),
      ),
    );
  }
}

/// ------------------ FILTERS + SEARCH ------------------
class _FiltersBar extends StatefulWidget {
  final ValueChanged<String> onSearchChanged;
  const _FiltersBar({required this.onSearchChanged});
  @override
  State<_FiltersBar> createState() => _FiltersBarState();
}

class _FiltersBarState extends State<_FiltersBar> {
  final _search = TextEditingController();
  double _elev = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: Row(
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFEFE4DE)),
                boxShadow: [
                  if (_elev > 0)
                    BoxShadow(
                      color: Colors.black.withOpacity(.06),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                ],
              ),
              child: FocusScope(
                child: Focus(
                  onFocusChange: (f) => setState(() => _elev = f ? 1 : 0),
                  child: TextField(
                    controller: _search,
                    onChanged: widget.onSearchChanged,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'search_queue_placeholder'.tr(),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          _GlassIcon(
            icon: Icons.tune,
            onTap: () {
              HapticFeedback.selectionClick();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('filter_all'.tr())));
            },
          ),
        ],
      ),
    );
  }
}

class _GlassIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _GlassIcon({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Material(
          color: Colors.white.withOpacity(.16),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(icon, color: Colors.black87),
            ),
          ),
        ),
      ),
    );
  }
}

/// ------------------ CONTENT (Orders) ------------------
class _OrdersTab extends StatelessWidget {
  final String search;
  final String? floorFilter;
  final String? officeFilter;
  final OrderStatus? selectedStatus;
  final ValueChanged<String?> onFloorChanged;
  final ValueChanged<String?> onOfficeChanged;

  const _OrdersTab({
    required this.search,
    required this.floorFilter,
    required this.officeFilter,
    required this.selectedStatus,
    required this.onFloorChanged,
    required this.onOfficeChanged,
  });

  @override
  Widget build(BuildContext context) {
    Future<Result<List<Items>>> repo(GetListRequest req) async {
      final c = context.read<OfficeBoyCubit>();
      final r = await c.fetchAllOrderServies(req);
      if (r.hasDataOnly) {
        final flattened = <Items>[];
        for (final m in (r.data ?? <OfficeBoyModel>[])) {
          if (m.items != null) flattened.addAll(m.items!);
        }
        return Result<List<Items>>(data: flattened);
      }
      return Result<List<Items>>(error: r.error ?? 'Unknown error');
    }

    return PaginationList<Items>(
      repositoryCallBack: (data) => repo(data as GetListRequest),
      withPagination: true,
      withRefresh: true,
      listBuilder: (list) {
        final base = list;
        final floors = _distinct(base.map((e) => e.floorName));
        final officesBase = floorFilter == null
            ? base
            : base.where((e) => _eq(e.floorName, floorFilter));
        final offices = _distinct(officesBase.map((e) => e.officeName));

        var filtered = base;
        if (selectedStatus != null) {
          filtered = filtered
              .where((e) => OrderStatus.fromInt(e.status) == selectedStatus)
              .toList();
        }
        filtered = _applyFilters(filtered, search, floorFilter, officeFilter);

        return Column(
          children: [
            _ChipsBar(
              floors: floors,
              floorValue: floorFilter,
              onFloorChanged: onFloorChanged,
              offices: offices,
              officeValue: officeFilter,
              onOfficeChanged: onOfficeChanged,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: filtered.isEmpty
                  ? const _EmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      physics: const BouncingScrollPhysics(),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) =>
                          _OrderCard(item: filtered[i], index: i),
                    ),
            ),
          ],
        );
      },
    );
  }
}

/// ------------------ ORDER CARD ------------------
class _OrderCard extends StatelessWidget {
  final Items item;
  final int index;
  const _OrderCard({required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    final status = _mapUI(item.status);
    final drinks = (item.orderItems ?? [])
        .map((e) => '${e.drink?.name ?? '-'} ×${e.quantity ?? 1}')
        .join(' • ');
    final borderColor = _statusColor(status).withOpacity(.28);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 16.0, end: 0.0),
      duration: Duration(milliseconds: 160 + index * 14),
      curve: Curves.easeOutCubic,
      builder: (_, dy, __) {
        return Transform.translate(
          offset: Offset(0, dy),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.05),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: .6, sigmaY: .6),
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // top row
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '#${item.id ?? '--'}',
                              style: AppTextStyle.getBoldStyle(
                                fontSize: AppFontSize.size_16,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          _StatusPill(status: status),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // place
                      Row(
                        children: [
                          const Icon(
                            Icons.place_outlined,
                            size: 16,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '${item.floorName ?? '-'} / ${item.officeName ?? '-'}',
                              style: AppTextStyle.getRegularStyle(
                                fontSize: AppFontSize.size_12,
                                color: AppColors.secondPrimery,
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (drinks.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          drinks,
                          style: AppTextStyle.getRegularStyle(
                            fontSize: AppFontSize.size_12,
                            color: AppColors.black,
                          ),
                        ),
                      ],

                      if ((item.orderItems ?? []).any(
                        (e) => (e.notes ?? '').trim().isNotEmpty,
                      )) ...[
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
                                (item.orderItems ?? [])
                                    .map((e) => (e.notes ?? '').trim())
                                    .where((t) => t.isNotEmpty)
                                    .join('\n'),
                                style: AppTextStyle.getRegularStyle(
                                  fontSize: AppFontSize.size_12,
                                  color: AppColors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _GhostBtn(
                            icon: Icons.description_outlined,
                            label: 'btn_details'.tr(),
                            onTap: () => _openDetails(context, item),
                          ),
                          const Spacer(),
                          _GhostBtn(
                            icon: Icons.swap_horiz_rounded,
                            label: 'Change status',
                            onTap: () => _showStatusSheet(context, item),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _openDetails(BuildContext context, Items item) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => _OrderDetails(item: item)));
  }
}

class _GhostBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _GhostBtn({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEFE4DE)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: AppColors.xprimaryColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: AppColors.xprimaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ------------------ STATUS SHEET ------------------
void _showStatusSheet(
  BuildContext context,
  Items item, {
  OrderStatus? initial,
}) {
  final statuses = OrderStatus.values;
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder: (_) {
      var selected = initial ?? OrderStatus.submitted;
      return StatefulBuilder(
        builder: (context, setSt) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                Text(
                  'Change order status',
                  style: AppTextStyle.getBoldStyle(
                    fontSize: AppFontSize.size_16,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final s in statuses)
                      ChoiceChip(
                        label: Text(_keyLabel(s).tr()),
                        selected: selected == s,
                        onSelected: (_) => setSt(() => selected = s),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.xprimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.save),
                    label: const Text('Save'),
                    onPressed: () async {
                      Navigator.pop(context);
                    final ok = await context
                          .read<OfficeBoyCubit>()
                          .updateOrderStatusBool(
                            orderId: item.id ?? '',
                            status: Core.OrderStatus.ready, // مثال
                          );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            ok ? 'Status updated' : 'Update failed',
                          ),
                        ),
                      );

                    },
                  ),
                ),
                const SizedBox(height: 6),
              ],
            ),
          );
        },
      );
    },
  );
}

String _keyLabel(OrderStatus s) {
  switch (s) {
    case OrderStatus.draft:
      return 'status_draft';
    case OrderStatus.submitted:
      return 'status_submitted';
    case OrderStatus.inPreparation:
      return 'status_in_preparation';
    case OrderStatus.ready:
      return 'status_ready';
    case OrderStatus.delivered:
      return 'status_delivered';
    case OrderStatus.canceled:
      return 'status_canceled';
  }
}

/// ------------------ DETAILS ------------------
class _OrderDetails extends StatelessWidget {
  final Items item;
  const _OrderDetails({required this.item});
  @override
  Widget build(BuildContext context) {
    final createdAt = item.creationTime ?? '-';
    return Scaffold(
      backgroundColor: const Color(0xFFF6EDE7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.xprimaryColor,
        title: Text('order_id'.tr(namedArgs: {'id': item.id ?? '--'})),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: 'section_order_info'.tr(),
            child: Column(
              children: [
                _KV(
                  'info_status'.tr(),
                  _keyLabel(OrderStatus.fromInt(item.status)!).tr(),
                ),
                _KV(
                  'info_customer'.tr(),
                  item.customerUser?.name ?? item.customerUser?.userName ?? '-',
                ),
                _KV(
                  'floor_office'.tr(),
                  '${item.floorName ?? '-'} / ${item.officeName ?? '-'}',
                ),
                _KV('info_created_at'.tr(), createdAt),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _Section(
            title: 'section_items'.tr(),
            child: Column(
              children: (item.orderItems ?? []).map((oi) {
                final d = oi.drink;
                final n = d?.name ?? d?.nameAr ?? d?.nameBe ?? '-';
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFEFE4DE)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$n ×${oi.quantity ?? 1}',
                        style: AppTextStyle.getBoldStyle(
                          fontSize: AppFontSize.size_14,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          if (oi.sugarLevel != null)
                            _Chip(
                              text: '${'info_sugar'.tr()}: ${oi.sugarLevel}',
                            ),
                          if ((oi.notes ?? '').isNotEmpty)
                            _Chip(text: oi.notes!),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
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
        borderRadius: BorderRadius.circular(14),
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
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _KV extends StatelessWidget {
  final String k, v;
  const _KV(this.k, this.v);
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
            k,
            style: AppTextStyle.getRegularStyle(
              fontSize: AppFontSize.size_12,
              color: AppColors.secondPrimery,
            ),
          ),
          const Spacer(),
          Text(
            v,
            style: AppTextStyle.getBoldStyle(
              fontSize: AppFontSize.size_12,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  const _Chip({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.xprimaryColor.withOpacity(.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.xprimaryColor.withOpacity(.25)),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}

/// ------------------ STATUS UI HELPERS ------------------
enum _UIStatus { draft, submitted, inPreparation, ready, delivered, canceled }

_UIStatus _mapUI(int? s) {
  switch (s) {
    case 0:
      return _UIStatus.draft;
    case 1:
      return _UIStatus.submitted;
    case 2:
      return _UIStatus.inPreparation;
    case 3:
      return _UIStatus.ready;
    case 4:
      return _UIStatus.delivered;
    case 5:
      return _UIStatus.canceled;
    default:
      return _UIStatus.draft;
  }
}

Color _statusColor(_UIStatus s) {
  switch (s) {
    case _UIStatus.draft:
      return AppColors.secondPrimery;
    case _UIStatus.submitted:
      return AppColors.lightOrange;
    case _UIStatus.inPreparation:
      return AppColors.xprimaryColor;
    case _UIStatus.ready:
      return AppColors.green32;
    case _UIStatus.delivered:
      return AppColors.secondPrimery;
    case _UIStatus.canceled:
      return Colors.red;
  }
}

class _StatusPill extends StatelessWidget {
  final _UIStatus status;
  const _StatusPill({required this.status});
  @override
  Widget build(BuildContext context) {
    final fg = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: fg.withOpacity(.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _statusText(status),
        style: AppTextStyle.getBoldStyle(
          fontSize: AppFontSize.size_12,
          color: fg,
        ),
      ),
    );
  }
}

String _statusText(_UIStatus s) {
  switch (s) {
    case _UIStatus.draft:
      return 'status_draft'.tr();
    case _UIStatus.submitted:
      return 'status_submitted'.tr();
    case _UIStatus.inPreparation:
      return 'status_in_preparation'.tr();
    case _UIStatus.ready:
      return 'status_ready'.tr();
    case _UIStatus.delivered:
      return 'status_delivered'.tr();
    case _UIStatus.canceled:
      return 'status_canceled'.tr();
  }
}

/// ------------------ FILTER HELPERS ------------------
List<Items> _applyFilters(
  List<Items> src,
  String search,
  String? floor,
  String? office,
) {
  var out = src;
  if (search.trim().isNotEmpty) {
    final q = search.toLowerCase().trim();
    out = out.where((e) {
      bool contains(String? s) => (s ?? '').toLowerCase().contains(q);
      final inId = contains(e.id);
      final inOffice = contains(e.officeName);
      final inFloor = contains(e.floorName);
      final inDrink = (e.orderItems ?? []).any(
        (it) => contains(it.drink?.name),
      );
      return inId || inOffice || inFloor || inDrink;
    }).toList();
  }
  if (floor != null) out = out.where((e) => _eq(e.floorName, floor)).toList();
  if (office != null)
    out = out.where((e) => _eq(e.officeName, office)).toList();
  return out;
}

bool _eq(String? a, String? b) =>
    (a ?? '').trim().toLowerCase() == (b ?? '').trim().toLowerCase();

List<String> _distinct(Iterable<String?> it) {
  final s = <String>{}, out = <String>[];
  for (final v in it) {
    if (v == null) continue;
    final key = v.trim().toLowerCase();
    if (key.isEmpty || s.contains(key)) continue;
    s.add(key);
    out.add(v);
  }
  return out;
}
// === CHIPS BAR ===
class _ChipsBar extends StatelessWidget {
  final List<String> floors;
  final String? floorValue;
  final ValueChanged<String?> onFloorChanged;
  final List<String> offices;
  final String? officeValue;
  final ValueChanged<String?> onOfficeChanged;
  const _ChipsBar({
    required this.floors,
    required this.floorValue,
    required this.onFloorChanged,
    required this.offices,
    required this.officeValue,
    required this.onOfficeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _DropChip<String>(
            label: 'filter_floor'.tr(),
            values: floors,
            value: floorValue,
            onChanged: onFloorChanged,
          ),
          const SizedBox(width: 8),
          _DropChip<String>(
            label: 'filter_office'.tr(),
            values: offices,
            value: officeValue,
            onChanged: onOfficeChanged,
          ),
        ],
      ),
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
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEFE4DE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T?>(
          isDense: true,
          value: value,
          hint: Text(label),
          onChanged: onChanged,
          items: <DropdownMenuItem<T?>>[
            DropdownMenuItem<T?>(value: null, child: Text('filter_all'.tr())),
            ...values.map(
              (e) => DropdownMenuItem<T?>(value: e as T?, child: Text('$e')),
            ),
          ],
        ),
      ),
    );
  }
}

// === EMPTY STATE ===
class _EmptyState extends StatelessWidget {
  const _EmptyState({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.inbox_outlined,
              size: 38,
              color: Color(0xFFBDBDBD),
            ),
            const SizedBox(height: 8),
            Text(
              'empty_queue'.tr(),
              style: AppTextStyle.getRegularStyle(
                fontSize: AppFontSize.size_14,
                color: AppColors.secondPrimery,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
