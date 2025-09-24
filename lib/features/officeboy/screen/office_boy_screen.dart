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

/// شاشة طلبات Office Boy بأربعة تبويبات حسب الحالة (0 / 1 / 4 / 5)
/// - لا تعديل على core.
/// - لكل تبويب OfficeBoyCubit مستقل.
/// - PaginationList كما هي، ونفرد items للعرض.
class OfficeBoyOrdersScreen extends StatefulWidget {
  const OfficeBoyOrdersScreen({super.key});

  @override
  State<OfficeBoyOrdersScreen> createState() => _OfficeBoyOrdersScreenState();
}

class _OfficeBoyOrdersScreenState extends State<OfficeBoyOrdersScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  /// نخزن PaginationCubit لكل حالة لتحديثها بالزر.
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
    return BlocProvider<OfficeBoyCubit>(
      create: (_) => OfficeBoyCubit(),
      child: Builder(
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
                for (final page in apiList)
                  if (page.items != null) ...page.items!,
              ];

              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPaddingSize.padding_16,
                      vertical: AppPaddingSize.padding_12,
                    ),
                    sliver: SliverList.separated(
                      itemCount: orders.length,
                      itemBuilder: (_, index) =>
                          _OrderCard(order: orders[index]),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.xbackgroundColor3,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text(
          'Office Boy Orders',
          style: TextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.size_18,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: AppColors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppColors.xprimaryColor,
              unselectedLabelColor: AppColors.grey89,
              indicatorColor: AppColors.xprimaryColor,
              indicatorWeight: 3,
              tabs: _tabs
                  .map((t) => Tab(icon: Icon(t.icon), text: t.label))
                  .toList(),
            ),
          ),
        ),
      ),
      body: TabBarView(
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.xprimaryColor,
        onPressed: () {
          final currentStatus = _tabs[_tabController.index].status;
          final cubit = _tabPaginationCubits[currentStatus];

          cubit;
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

/// بطاقة عرض الطلب (Items)
class _OrderCard extends StatelessWidget {
  final Items order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final String? orderId = order.id;
    final int? status = order.status;

    final String? customerName = order.customerUser?.name; // مباشرة من الموديل
    final String? floorName = order.floorName; // مباشرة من الموديل
    final String? officeName = order.officeName; // مباشرة من الموديل
    final String? createdAt = order.creationTime; // مباشرة من الموديل

    final List<OrderItems> items = order.orderItems ?? const [];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppFontSize.size_14),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppPaddingSize.padding_14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // رأس البطاقة: الحالة + المعرف
          Row(
            children: [
              _StatusPill(status: status ?? -1),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              if (customerName != null)
                Flexible(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 16,
                        color: AppColors.black,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          customerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: AppFontSize.size_15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (customerName != null &&
                  (floorName != null || officeName != null))
                const SizedBox(width: 10),
              if (floorName != null || officeName != null)
                Flexible(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.apartment_outlined,
                        size: 16,
                        color: AppColors.black,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          // مباشرة من الموديل بدون fallbacks
                          [floorName, officeName].join(' • '),
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
                ),
            ],
          ),

          // وقت الإنشاء
          if (createdAt != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppColors.grey89,
                ),
                const SizedBox(width: 6),
                Text(
                  createdAt,
                  style: const TextStyle(
                    fontSize: AppFontSize.size_12,
                    color: AppColors.grey89,
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 12),
          _OrderItemsList(items: items),

          const SizedBox(height: 10),
          // أزرار Accept/Cancel + (اختياري) تغيير الحالة
          Row(
            children: [
              _ActionBtn(
                icon: Icons.check_circle_outline,
                label: 'Accept',
                color: Colors.green,
                onTap: (status == 1 || status == 4 || status == 5)
                    ? null
                    : () => _changeStatus(context, order, 1),
              ),
              const SizedBox(width: 8),
              _ActionBtn(
                icon: Icons.cancel_outlined,
                label: 'Cancel',
                color: Colors.red,
                onTap: (status == 4 || status == 5)
                    ? null
                    : () => _changeStatus(context, order, 5),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => _showChangeStatusSheet(context, order),
                icon: const Icon(Icons.swap_horiz_rounded),
                label: const Text('تغيير الحالة'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.xprimaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// استدعاء تحديث الحالة عبر Cubit
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

    // حسب طلبك: ما في refresh هنا؛ اترك الاسترجاع لميكانيزمك الخاص أو لفاب
    cubit.drinkCubit;
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: disabled ? Colors.grey.shade200 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: disabled ? Colors.grey.shade300 : color.withOpacity(.5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: disabled ? Colors.grey : color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: disabled ? Colors.grey : color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
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
        // مباشرة من الموديل بدون fallbacks
        final String? name = e.drink?.name;
        final int? qty = e.quantity;
        final int? sugar = e.sugarLevel;
        final String? notes = e.notes;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(AppPaddingSize.padding_12),
          decoration: BoxDecoration(
            color: AppColors.whiteF3,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
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
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
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
        color: c.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: c),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: c,
              fontSize: AppFontSize.size_12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  static Color _statusColor(int status) {
    switch (status) {
      case 0:
        return Colors.orange; // Pending
      case 1:
        return Colors.blue; // In-Progress
      case 4:
        return Colors.green; // Completed
      case 5:
        return Colors.red; // Cancelled
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

/// BottomSheet لتغيير الحالة (اختياري)
void _showChangeStatusSheet(BuildContext context, Items order) {
  final List<int> allowed = [0, 1, 4, 5];
  int selected = order.status ?? 0;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
      return StatefulBuilder(
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
                style: TextStyle(
                  fontSize: AppFontSize.size_16,
                  fontWeight: FontWeight.w700,
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
                  // حسب طلبك: ما في refresh هنا
                  cubit.drinkCubit;
                  if (context.mounted) Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    },
  );
}
