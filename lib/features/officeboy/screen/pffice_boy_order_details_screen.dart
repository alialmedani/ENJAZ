import 'package:enjaz/features/officeboy/cubit/cubit/office_boy_cubit.dart';
import 'package:enjaz/features/officeboy/data/usecase/status_order_usecase.dart';
import 'package:enjaz/features/officeboy/screen/office_boy_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/features/officeboy/data/model/officeboy_model.dart';

class OfficeBoyOrderDetailsScreen extends StatefulWidget {
  final Items order;
  const OfficeBoyOrderDetailsScreen({super.key, required this.order});

  @override
  State<OfficeBoyOrderDetailsScreen> createState() =>
      _OfficeBoyOrderDetailsScreenState();
}

class _OfficeBoyOrderDetailsScreenState
    extends State<OfficeBoyOrderDetailsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutQuart),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    // Start animations
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int? status = widget.order.status;
    final String? customerName = widget.order.customerUser?.name;
    final String? floorName = widget.order.floorName;
    final String? officeName = widget.order.officeName;
    final String? createdAt = widget.order.creationTime;
    final List<OrderItems> items = widget.order.orderItems ?? const [];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Modern App Bar with Gradient
          SliverAppBar(
            expandedHeight: 220,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.black,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: FadeTransition(
                opacity: _fadeAnimation,
                child: _ModernDetailsHeader(
                  status: status ?? -1,
                  customerName: customerName ?? '—',
                  floorName: floorName,
                  officeName: officeName,
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Timeline
                      if (createdAt != null) ...[
                        _ModernSectionHeader(
                          icon: Icons.schedule_outlined,
                          title: 'Order Timeline',
                          subtitle: 'Track your order progress',
                        ),
                        const SizedBox(height: 16),
                        _OrderTimeline(
                          createdAt: createdAt,
                          status: status ?? -1,
                        ),
                        const SizedBox(height: 32),
                      ],

                      // Items Section
                      _ModernSectionHeader(
                        icon: Icons.local_cafe_outlined,
                        title: 'Order Items',
                        subtitle:
                            '${items.length} item${items.length != 1 ? 's' : ''} in this order',
                      ),
                      const SizedBox(height: 16),

                      if (items.isEmpty)
                        _EmptyState()
                      else
                        _ItemsList(items: items),

                      const SizedBox(height: 32),

                      // Actions Section
                      _ModernSectionHeader(
                        icon: Icons.tune_outlined,
                        title: 'Quick Actions',
                        subtitle: 'Update order status',
                      ),
                      const SizedBox(height: 16),
                      _ModernActionButtons(
                        status: status ?? -1,
                        onStatusUpdate: (newStatus) =>
                            _updateStatus(context, widget.order, newStatus),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateStatus(
    BuildContext context,
    Items order,
    int newStatus,
  ) async {
    // بنستخدم نفس الكيوبت اللي عندك عبر السياق الأعلى
    final cubit = context.read<OfficeBoyCubit>();
    cubit.updateOrderStatusParams = UpdateOrderStatusParams(
      orderId: order.id ?? '',
      status: newStatus,
    );
    await cubit.updateOrderStatusBool();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Status updated to ${StatusPill.statusLabel(newStatus)}',
          ),
        ),
      );
    }
  }
}

// ================== Modern Beautiful Widgets ==================

class _ModernDetailsHeader extends StatelessWidget {
  final int status;
  final String customerName;
  final String? floorName;
  final String? officeName;

  const _ModernDetailsHeader({
    required this.status,
    required this.customerName,
    required this.floorName,
    required this.officeName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
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
          // Animated background patterns
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),

          // Content
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _getStatusColor(status),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          StatusPill.statusLabel(status),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Customer Name
                  Text(
                    customerName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Location Info
                  if (floorName != null || officeName != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            [
                              if (floorName != null) floorName!,
                              if (officeName != null) officeName!,
                            ].join(' • '),
                            style: const TextStyle(
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
        ],
      ),
    );
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 1:
        return Colors.blue;
      case 4:
        return Colors.green;
      case 5:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}

class _ModernSectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ModernSectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.xprimaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.xprimaryColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.grey89.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _OrderTimeline extends StatelessWidget {
  final String createdAt;
  final int status;

  const _OrderTimeline({required this.createdAt, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TimelineItem(
            icon: Icons.access_time,
            title: 'Order Created',
            subtitle: createdAt,
            isCompleted: true,
            color: Colors.blue,
          ),
          _TimelineConnector(isActive: status >= 1),
          _TimelineItem(
            icon: Icons.check_circle_outline,
            title: 'Order Accepted',
            subtitle: status >= 1 ? 'In progress' : 'Waiting for acceptance',
            isCompleted: status >= 1,
            color: Colors.orange,
          ),
          _TimelineConnector(isActive: status >= 4),
          _TimelineItem(
            icon: Icons.done_all,
            title: 'Order Completed',
            subtitle: status == 4
                ? 'Delivered successfully'
                : status == 5
                ? 'Order cancelled'
                : 'In progress...',
            isCompleted: status == 4,
            color: status == 5 ? Colors.red : Colors.green,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isCompleted;
  final Color color;
  final bool isLast;

  const _TimelineItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    required this.color,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isCompleted ? color : Colors.grey.shade200,
                shape: BoxShape.circle,
                boxShadow: isCompleted
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                icon,
                color: isCompleted ? Colors.white : Colors.grey.shade400,
                size: 20,
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isCompleted ? AppColors.black : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimelineConnector extends StatelessWidget {
  final bool isActive;

  const _TimelineConnector({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 19.5),
      width: 1,
      height: 24,
      color: isActive ? AppColors.xprimaryColor : Colors.grey.shade300,
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_cafe_outlined,
              color: Colors.grey.shade400,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Items Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'There are no items in this order',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _ItemsList extends StatelessWidget {
  final List<OrderItems> items;

  const _ItemsList({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;

        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: _ModernItemCard(item: item),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

class _ModernItemCard extends StatelessWidget {
  final OrderItems item;

  const _ModernItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Item Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.xprimaryColor.withValues(alpha: 0.1),
                  AppColors.xprimaryColor.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.local_cafe,
              color: AppColors.xprimaryColor,
              size: 24,
            ),
          ),

          const SizedBox(width: 16),

          // Item Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.drink?.name ?? 'Unknown Item',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _ModernChip(
                      icon: Icons.numbers,
                      label: 'Qty: ${item.quantity ?? 0}',
                      color: Colors.blue,
                    ),
                    _ModernChip(
                      icon: Icons.local_cafe,
                      label: 'Sugar: ${item.sugarLevel ?? 'None'}',
                      color: Colors.orange,
                    ),
                    if (item.notes != null && item.notes!.isNotEmpty)
                      _ModernChip(
                        icon: Icons.note,
                        label: item.notes!,
                        color: Colors.green,
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

class _ModernChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ModernChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModernActionButtons extends StatelessWidget {
  final int status;
  final Function(int) onStatusUpdate;

  const _ModernActionButtons({
    required this.status,
    required this.onStatusUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Primary Actions Row
        Row(
          children: [
            Expanded(
              child: _ModernActionButton(
                icon: Icons.check_circle_outline,
                label: 'Accept',
                subtitle: 'Start working',
                color: const Color(0xFF3B82F6),
                isEnabled: status != 1 && status != 4 && status != 5,
                onTap: () => onStatusUpdate(1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ModernActionButton(
                icon: Icons.task_alt_outlined,
                label: 'Complete',
                subtitle: 'Mark as done',
                color: const Color(0xFF10B981),
                isEnabled: status != 4 && status != 5,
                onTap: () => onStatusUpdate(4),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Secondary Action
        _ModernActionButton(
          icon: Icons.cancel_outlined,
          label: 'Cancel Order',
          subtitle: 'Cannot complete this order',
          color: const Color(0xFFEF4444),
          isEnabled: status != 4 && status != 5,
          onTap: () => onStatusUpdate(5),
          isFullWidth: true,
        ),
      ],
    );
  }
}

class _ModernActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final bool isEnabled;
  final VoidCallback onTap;
  final bool isFullWidth;

  const _ModernActionButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.isEnabled,
    required this.onTap,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onTap : null,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: isFullWidth ? double.infinity : null,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isEnabled ? Colors.white : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isEnabled
                    ? color.withValues(alpha: 0.3)
                    : Colors.grey.shade300,
                width: 1.5,
              ),
              boxShadow: isEnabled
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  color: isEnabled ? color : Colors.grey.shade400,
                  size: 24,
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: isEnabled ? color : Colors.grey.shade400,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isEnabled
                        ? Colors.grey.shade600
                        : Colors.grey.shade400,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
