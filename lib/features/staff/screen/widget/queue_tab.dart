// // lib/features/staff/widgets/queue_tab.dart
// import 'package:easy_localization/easy_localization.dart';
// import 'package:enjaz/features/staff/cubit/ccubit1.dart';
// import 'package:enjaz/features/staff/cubit/staff_orders_cubit.dart';
// import 'package:enjaz/features/staff/data/model/staff_order.dart';
// import 'package:enjaz/features/staff/screen/staff_order_details_screen.dart';
// import 'package:enjaz/features/staff/screen/widget/section.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:enjaz/core/constant/app_colors/app_colors.dart';
//  import 'quick_bar.dart';
//  import 'status_pill.dart';
// import 'sla_countdown.dart';
 
// class QueueTab extends StatefulWidget {
//   const QueueTab({super.key});
//   @override
//   State<QueueTab> createState() => _QueueTabState();
// }

// class _QueueTabState extends State<QueueTab> {
//   String _search = '';
//   int? _floorFilter;
//   int? _officeFilter;

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<StaffOrdersCubit, StaffOrdersState>(
//       builder: (context, st) {
//         final items = st.all.where(
//           (o) =>
//               o.scheduleType == ScheduleType.none &&
//               (o.status == StaffOrderStatus.pending ||
//                   o.status == StaffOrderStatus.inProgress),
//         );

//         var list = items
//             .where(
//               (o) =>
//                   _search.isEmpty ||
//                   o.itemName.toLowerCase().contains(_search.toLowerCase()) ||
//                   o.id.toLowerCase().contains(_search.toLowerCase()),
//             )
//             .toList();

//         if (_floorFilter != null)
//           list = list.where((o) => o.floor == _floorFilter).toList();
//         if (_officeFilter != null)
//           list = list.where((o) => o.office == _officeFilter).toList();

//         return Column(
//           children: [
//             QuickBar(
//               placeholder: 'search_queue_placeholder'.tr(),
//               onChanged: (v) => setState(() => _search = v),
//               onRefresh: () => context.read<StaffOrdersCubit>().refresh(),
//               filters: [
//                 DropChip<int>(
//                   label: 'filter_floor'.tr(),
//                   values: const [1, 2, 3, 4, 5],
//                   value: _floorFilter,
//                   onChanged: (v) => setState(() => _floorFilter = v),
//                 ),
//                 DropChip<int>(
//                   label: 'filter_office'.tr(),
//                   values: const [1, 2, 3, 4, 5, 6],
//                   value: _officeFilter,
//                   onChanged: (v) => setState(() => _officeFilter = v),
//                 ),
//               ],
//             ),
//             // Expanded(
//             //   child: st.loading
//             //       ? Center(
//             //           child: CircularProgressIndicator(
//             //             color: AppColors.xprimaryColor,
//             //           ),
//             //         )
//             //       : list.isEmpty
//             //       ? EmptyView(message: 'empty_queue'.tr())
//             //       : ListView.separated(
//             //           padding: const EdgeInsets.all(16),
//             //           physics: const BouncingScrollPhysics(),
//             //           itemCount: list.length,
//             //           separatorBuilder: (_, __) => const SizedBox(height: 12),
//             //           itemBuilder: (_, i) {
//             //             final o = list[i];
//             //             return FadeSlideIn(
//             //               delay: Duration(milliseconds: 60 * i),
//             //               child: _QueueCard(order: o),
//             //             );
//             //           },
//             //         ),
//             // ),
//           ],
//         );
//       },
//     );
//   }
// }

// class _QueueCard extends StatelessWidget {
//   final StaffOrder order;
//   const _QueueCard({required this.order});

//   @override
//   Widget build(BuildContext context) {
//     final cubit = context.read<StaffOrdersCubit>();
//     final orange = AppColors.xprimaryColor;

//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.06),
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   'item_x_qty'.tr(
//                     namedArgs: {
//                       'name': order.itemName,
//                       'size': order.size,
//                       'qty': '${order.quantity}',
//                     },
//                   ),
//                 ),
//               ),
//               StatusPill(status: order.status),
//             ],
//           ),
//           const SizedBox(height: 6),
//           Text(
//             'floor_office'.tr(
//               namedArgs: {
//                 'floor': '${order.floor}',
//                 'office': '${order.office}',
//               },
//             ),
//           ),
//           if ((order.customerNote ?? '').isNotEmpty) ...[
//             const SizedBox(height: 6),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Icon(
//                   Icons.sticky_note_2_outlined,
//                   size: 16,
//                   color: Colors.orange,
//                 ),
//                 const SizedBox(width: 6),
//                 Expanded(child: Text(order.customerNote!)),
//               ],
//             ),
//           ],
//           const SizedBox(height: 10),
//           Row(
//             children: [
//               SlaCountdown(dueAt: order.dueAt),
//               const Spacer(),
//               if (order.status == StaffOrderStatus.pending)
//                 TextButton(
//                   onPressed: () => cubit.accept(order),
//                   child: Text('btn_accept'.tr()),
//                 ),
//               if (order.status == StaffOrderStatus.inProgress)
//                 TextButton(
//                   onPressed: () => cubit.markReady(order),
//                   child: Text('btn_ready'.tr()),
//                 ),
//               if (order.status == StaffOrderStatus.ready)
//                 TextButton(
//                   onPressed: () => cubit.markDelivered(order),
//                   child: Text('btn_delivered'.tr()),
//                 ),
//               const SizedBox(width: 8),
//               // OutlinedButton.icon(
//               //   // onPressed: () => Navigator.of(context).push(
//               //   //   // MaterialPageRoute(
//               //   //   //   // builder: (_) => StaffOrderDetailsScreen(order: order),
//               //   //   // ),
//               //   // ),
//               //   icon: const Icon(Icons.description),
//               //   label: Text('btn_details'.tr()),
//               //   style: OutlinedButton.styleFrom(foregroundColor: orange),
//               // ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
