import 'dart:ui';

import 'package:enjaz/features/officeboy/cubit/cubit/office_boy_cubit.dart';
import 'package:enjaz/features/officeboy/data/usecase/get_order_usecase.dart';
import 'package:enjaz/features/officeboy/data/usecase/status_order_usecase.dart';
import 'package:enjaz/features/officeboy/screen/office_boy_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:enjaz/core/boilerplate/pagination/widgets/pagination_list.dart';
import 'package:enjaz/core/boilerplate/pagination/cubits/pagination_cubit.dart';
import 'package:enjaz/core/constant/app_colors/app_colors.dart';
import 'package:enjaz/core/constant/text_styles/font_size.dart';
import 'package:enjaz/core/constant/app_padding/app_padding.dart';

import 'package:enjaz/features/officeboy/data/model/officeboy_model.dart';

class OfficeBoyOrderDetailsScreen extends StatelessWidget {
  final Items order;
  const OfficeBoyOrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final int? status = order.status;
    final String? customerName = order.customerUser?.name;
    final String? floorName = order.floorName;
    final String? officeName = order.officeName;
    final String? createdAt = order.creationTime;
    final List<OrderItems> items = order.orderItems ?? const [];

    return Scaffold(
      backgroundColor: AppColors.xbackgroundColor3,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: AppColors.black),
        title: const Text(
          'Order Details',
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.w800),
        ),
      ),
      body: Column(
        children: [
          // هيدر جميل
          _DetailsHeader(
            status: status ?? -1,
            customerName: customerName ?? '—',
            floorName: floorName,
            officeName: officeName,
          ),

          // باقي المحتوى قابل للسكّрол
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(AppPaddingSize.padding_16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (createdAt != null) ...[
                    const _SectionTitle(
                      icon: Icons.schedule,
                      title: 'Created at',
                    ),
                    const SizedBox(height: 8),
                    _InfoTile(label: 'Time', value: createdAt),
                    const SizedBox(height: 18),
                  ],

                  // العناصر
                  const _SectionTitle(icon: Icons.local_cafe, title: 'Items'),
                  const SizedBox(height: 8),
                  if (items.isEmpty)
                    _SoftCard(
                      child: const Text(
                        'لا توجد عناصر في هذا الطلب',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: AppFontSize.size_13,
                        ),
                      ),
                    )
                  else
                     Column(
                      children: items.map((e) {
                         final String? note = (() {
                          
                        })();

                        return _SoftCard(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.local_cafe,
                                  color: AppColors.black,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                       Text(
                                        e.drink!.name!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: AppFontSize.size_15,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.black,
                                        ),
                                      ),
                                    const SizedBox(height: 6),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 6,
                                      children: [
                                        _Chip(label: 'Qty: ${e.quantity}'),
                                        _Chip(label: 'Sugar: ${e.sugarLevel}'),
                                        _Chip(label: 'Note: $note'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: 24),

                  // أزرار الإجراءات
                  const _SectionTitle(
                    icon: Icons.tune,
                    title: 'Actions (Status)',
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _PrimaryActionButton(
                          icon: Icons.check_circle_outline,
                          label: 'Accept / In-Progress',
                          color: Colors.blue,
                          onTap: (status == 1 || status == 4 || status == 5)
                              ? null
                              : () => _updateStatus(context, order, 1),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _PrimaryActionButton(
                          icon: Icons.task_alt_outlined,
                          label: 'Complete',
                          color: Colors.green,
                          onTap: (status == 4 || status == 5)
                              ? null
                              : () => _updateStatus(context, order, 4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _SecondaryActionButton(
                    icon: Icons.cancel_outlined,
                    label: 'Cancel',
                    color: Colors.red,
                    onTap: (status == 4 || status == 5)
                        ? null
                        : () => _updateStatus(context, order, 5),
                  ),

                  const SizedBox(height: 24),
                ],
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

// ================== Widgets مساعدة لواجهة التفاصيل ==================

class _DetailsHeader extends StatelessWidget {
  final int status;
  final String customerName;
  final String? floorName;
  final String? officeName;

  const _DetailsHeader({
    required this.status,
    required this.customerName,
    required this.floorName,
    required this.officeName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.xprimaryColor.withOpacity(.13),
            const Color(0xFFEAF2FF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // زجاج خفيف
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(color: Colors.white.withOpacity(.12)),
          ),
          Padding(
            padding: const EdgeInsets.all(AppPaddingSize.padding_16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // أيقونة
                Container(
                  width: 54,
                  height: 54,
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
                  child: const Icon(
                    Icons.local_cafe_outlined,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(width: 14),
                // نصوص
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StatusPill(status: status),
                      const SizedBox(height: 8),
                      Text(
                        customerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.black,
                          fontSize: AppFontSize.size_18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.apartment_outlined,
                            size: 16,
                            color: AppColors.grey89,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              [
                                if (floorName != null) floorName!,
                                if (officeName != null) officeName!,
                              ].join(' • '),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.grey89,
                                fontSize: AppFontSize.size_13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.black),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.size_15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: Row(
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.grey89),
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftCard extends StatelessWidget {
  final Widget child;
  const _SoftCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: AppPaddingSize.padding_6),
      padding: const EdgeInsets.all(AppPaddingSize.padding_12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.greyE5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.whiteF3,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.greyE5),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.black,
          fontSize: AppFontSize.size_12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  const _PrimaryActionButton({
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
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: disabled ? Colors.grey.shade200 : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: disabled ? Colors.grey.shade300 : color.withOpacity(.4),
          ),
          boxShadow: disabled
              ? null
              : [
                  BoxShadow(
                    color: color.withOpacity(.09),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: disabled ? Colors.grey : color),
            const SizedBox(width: 8),
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
    );
  }
}

class _SecondaryActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  const _SecondaryActionButton({
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
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: disabled ? Colors.grey.shade200 : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: disabled ? Colors.grey.shade300 : color.withOpacity(.4),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: disabled ? Colors.grey : color),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: disabled ? Colors.grey : color,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
