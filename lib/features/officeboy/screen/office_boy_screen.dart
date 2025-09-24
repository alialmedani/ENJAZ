import 'package:enjaz/core/classes/cashe_helper.dart';
import 'package:enjaz/core/utils/Navigation/navigation.dart';
import 'package:enjaz/features/auth/screen/login_screen.dart';
import 'package:enjaz/features/officeboy/cubit/cubit/office_boy_cubit.dart';
import 'package:enjaz/features/officeboy/data/usecase/get_order_usecase.dart';
import 'package:enjaz/features/officeboy/screen/pffice_boy_order_details_screen.dart';
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
    _StatusTab(label: 'Progress', status: 1, icon: Icons.run_circle_outlined),
    _StatusTab(label: 'Complete', status: 4, icon: Icons.check_circle_outline),
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
          withRefresh: true,
          withPagination: true,
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
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: _ModernHeader(),
              titlePadding: EdgeInsets.zero,
            ),
          ),

          // Tab Bar Section
          SliverPersistentHeader(
            pinned: true,
            delegate: _SafeTabBarDelegate(
              controller: _tabController,
              tabs: _tabs,
            ),
          ),

          // Content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              physics: const BouncingScrollPhysics(),
              children: _tabs
                  .map(
                    (t) => _buildStatusTab(
                      status: t.status,
                      emptyTitle: 'No orders for this status',
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

// ================== Modern Beautiful Components ==================

class _SafeTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController controller;
  final List<_StatusTab> tabs;

  _SafeTabBarDelegate({required this.controller, required this.tabs});

  static const double _verticalPadding = 8.0;
  static const double _horizontalPadding = 12.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(
      child: Container(
        color: const Color(0xFFF8FAFC),
        padding: const EdgeInsets.symmetric(vertical: _verticalPadding),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: _ModernTabBar(controller: controller, tabs: tabs),
        ),
      ),
    );
  }

  @override
  double get maxExtent => kTextTabBarHeight + (_verticalPadding * 2);

  @override
  double get minExtent => maxExtent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class _ModernHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF6366F1),
            const Color(0xFF8B5CF6),
            AppColors.xprimaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              onPressed: () {
                CacheHelper.box.clear();
                Navigation.pushAndRemoveUntil(LoginScreen());
              },
              icon: Icon(Icons.logout, color: Colors.white, size: 30),
            ),
          ),

          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App Title
                    const Text(
                      'Office Boy Orders',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Subtitle
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.coffee_outlined,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Manage and track order requests',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
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

class _ModernTabBar extends StatelessWidget {
  final TabController controller;
  final List<_StatusTab> tabs;

  const _ModernTabBar({required this.controller, required this.tabs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: controller,
        isScrollable: true,
        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
        dividerColor: Colors.transparent,
        tabAlignment: TabAlignment.center,
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.xprimaryColor,
              AppColors.xprimaryColor.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey.shade600,
        tabs: tabs.map((tab) => _ModernTab(tab: tab)).toList(),
      ),
    );
  }
}

class _ModernTab extends StatelessWidget {
  final _StatusTab tab;

  const _ModernTab({required this.tab});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon with subtle animation potential
          Icon(tab.icon, size: 16),
          const SizedBox(height: 3),
          // Label with better typography
          Flexible(
            child: Text(
              tab.label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
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
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Modern Illustration Container
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.xprimaryColor.withValues(alpha: 0.1),
                    AppColors.xprimaryColor.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.xprimaryColor.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.coffee_outlined,
                size: 48,
                color: AppColors.xprimaryColor.withValues(alpha: 0.7),
              ),
            ),

            const SizedBox(height: 24),

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // Subtitle
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 32),

            // Action Button
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.xprimaryColor.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: onCta,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(ctaLabel),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.xprimaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Items order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final int? status = order.status;
    final String? customerName = order.customerUser?.name;
    final String? floorName = order.floorName;
    final String? officeName = order.officeName;
    final List<OrderItems> items = order.orderItems ?? [];
    final int itemCount = items.length;

    return _PressableScale(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => OfficeBoyOrderDetailsScreen(order: order),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Customer Avatar
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.xprimaryColor.withValues(alpha: 0.2),
                          AppColors.xprimaryColor.withValues(alpha: 0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_outline,
                      color: AppColors.xprimaryColor,
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Customer Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customerName ?? 'Unknown Customer',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                [
                                  if (floorName != null) floorName,
                                  if (officeName != null) officeName,
                                ].join(' • '),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Status Badge
                  _ModernStatusPill(status: status ?? -1),
                ],
              ),

              const SizedBox(height: 16),

              // Order Summary
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_cafe_outlined,
                      color: AppColors.xprimaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$itemCount item${itemCount != 1 ? 's' : ''} ordered',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey.shade500,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModernStatusPill extends StatelessWidget {
  final int status;

  const _ModernStatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final statusInfo = _getStatusInfo(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusInfo.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusInfo.color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusInfo.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            statusInfo.label,
            style: TextStyle(
              color: statusInfo.color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  _StatusInfo _getStatusInfo(int status) {
    switch (status) {
      case 0:
        return _StatusInfo('Pending', Colors.orange);
      case 1:
        return _StatusInfo('In Progress', Colors.blue);
      case 4:
        return _StatusInfo('Completed', Colors.green);
      case 5:
        return _StatusInfo('Cancelled', Colors.red);
      default:
        return _StatusInfo('Unknown', Colors.grey);
    }
  }
}

class _StatusInfo {
  final String label;
  final Color color;
  _StatusInfo(this.label, this.color);
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

class StatusPill extends StatelessWidget {
  final int status;
  const StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final Color c = _statusColor(status);
    final String label = statusLabel(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
              fontSize: 12,
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
        return Colors.grey;
    }
  }

  static String statusLabel(int status) {
    switch (status) {
      case 0:
        return 'Pending';
      case 1:
        return 'In Progress';
      case 4:
        return 'Completed';
      case 5:
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }
}
