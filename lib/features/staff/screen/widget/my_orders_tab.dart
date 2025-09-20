// // lib/features/staff/widgets/my_orders_tab.dart
// import 'package:easy_localization/easy_localization.dart';
// import 'package:enjaz/features/profile/screen/widget/fade_slide_in.dart';
// import 'package:enjaz/features/staff/cubit/ccubit1.dart';
// import 'package:enjaz/features/staff/cubit/staff_orders_cubit.dart';
// import 'package:enjaz/features/staff/data/model/staff_order.dart' hide StaffOrderStatus;
// import 'package:enjaz/features/staff/screen/widget/section.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:enjaz/core/constant/app_colors/app_colors.dart';
//  import 'quick_bar.dart';
//  import 'status_pill.dart';
 
// class MyOrdersTab extends StatefulWidget {
//   const MyOrdersTab({super.key});
//   @override
//   State<MyOrdersTab> createState() => _MyOrdersTabState();
// }

// class _MyOrdersTabState extends State<MyOrdersTab> {
//   String _search = '';
//   final Set<StaffOrderStatus> _status = {
//     StaffOrderStatus.pending,
//     StaffOrderStatus.inProgress,
//     StaffOrderStatus.ready,
//     StaffOrderStatus.delivered,
//   };

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<StaffOrdersCubit, StaffOrdersState>(
//       builder: (context, st) {
//         var list = st.all.where((o) => (o.assignee == 'Me')).toList();
//         list = list.where((o) => _status.contains(o.status)).toList();
//         if (_search.isNotEmpty) {
//           list = list
//               .where(
//                 (o) =>
//                     o.itemName.toLowerCase().contains(_search.toLowerCase()) ||
//                     o.id.toLowerCase().contains(_search.toLowerCase()),
//               )
//               .toList();
//         }

//         return Column(
//           children: [
//             QuickBar(
//               placeholder: 'search_my_orders_placeholder'.tr(),
//               onChanged: (v) => setState(() => _search = v),
//               onRefresh: () => context.read<StaffOrdersCubit>().refresh(),
//               extra: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: StaffOrderStatus.values.map((s) {
//                     final active = _status.contains(s);
//                     return Padding(
//                       padding: const EdgeInsets.only(right: 8),
//                       child: ChoiceChip(
//                         selected: active,
//                         label: Text(_statusKey(s).tr()),
//                         onSelected: (_) => setState(
//                           () => active ? _status.remove(s) : _status.add(s),
//                         ),
//                         selectedColor: AppColors.xprimaryColor,
//                         labelStyle: TextStyle(
//                           color: active ? Colors.white : AppColors.black,
//                           fontWeight: active
//                               ? FontWeight.bold
//                               : FontWeight.normal,
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: st.loading
//                   ? Center(
//                       child: CircularProgressIndicator(
//                         color: AppColors.xprimaryColor,
//                       ),
//                     )
//                   : list.isEmpty
//                   ? EmptyView(message: 'empty_my_orders'.tr())
//                   : ListView.separated(
//                       padding: const EdgeInsets.all(16),
//                       physics: const BouncingScrollPhysics(),
//                       itemCount: list.length,
//                       separatorBuilder: (_, __) => const SizedBox(height: 12),
//                       itemBuilder: (_, i) {
//                         final o = list[i];
//                         return FadeSlideIn(
//                           delay: Duration(milliseconds: 60 * i),
//                           child: _MyOrderCard(order: o),
//                         );
//                       },
//                     ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   String _statusKey(StaffOrderStatus s) {
//     switch (s) {
//       case StaffOrderStatus.pending:
//         return 'status_pending';
//       case StaffOrderStatus.inProgress:
//         return 'status_in_progress';
//       case StaffOrderStatus.ready:
//         return 'status_ready';
//       case StaffOrderStatus.delivered:
//         return 'status_delivered';
//     }
//   }
// }

// class _MyOrderCard extends StatelessWidget {
//   final StaffOrder order;
//   const _MyOrderCard({required this.order});
//   @override
//   Widget build(BuildContext context) {
//     final cubit = context.read<StaffOrdersCubit>();
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
//           const SizedBox(height: 10),
//           Row(
//             children: [
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
//               const Spacer(),
//               OutlinedButton.icon(
//                 onPressed: () => Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (_) => StaffOrderDetailsScreen(order: order),
//                   ),
//                 ),
//                 icon: const Icon(Icons.description),
//                 label: Text('btn_details'.tr()),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class StaffProfileTabLight extends StatelessWidget {
//   const StaffProfileTabLight({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final totalOrders = context.select<StaffOrdersCubit, int>(
//       (c) => c.state.all.length,
//     );
//     final most = context.select<StaffOrdersCubit, String>((c) {
//       final map = <String, int>{};
//       for (final o in c.state.all) {
//         map[o.itemName] = (map[o.itemName] ?? 0) + 1;
//       }
//       if (map.isEmpty) return '-';
//       return (map.entries.toList()..sort((a, b) => b.value.compareTo(a.value)))
//           .first
//           .key;
//     });

//     return ListView(
//       padding: const EdgeInsets.all(16),
//       physics: const BouncingScrollPhysics(),
//       children: [
//         FadeSlideIn(
//           delay: const Duration(milliseconds: 80),
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(.06),
//                   blurRadius: 12,
//                   offset: const Offset(0, 6),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 const CircleAvatar(radius: 28, child: Icon(Icons.person)),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('profile_me_label'.tr()),
//                       const SizedBox(height: 4),
//                       Text(
//                         'profile_meta'.tr(
//                           namedArgs: {'floor': '2', 'office': '5'},
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
//         FadeSlideIn(
//           delay: const Duration(milliseconds: 160),
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(.06),
//                   blurRadius: 12,
//                   offset: const Offset(0, 6),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 _StatBox(
//                   title: 'stat_total_orders'.tr(),
//                   value: '$totalOrders',
//                 ),
//                 _StatBox(title: 'stat_most_drink'.tr(), value: most),
//                 _StatBox(
//                   title: 'stat_ready_now'.tr(),
//                   value:
//                       '${context.read<StaffOrdersCubit>().state.all.where((o) => o.status == StaffOrderStatus.ready).length}',
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _StatBox extends StatelessWidget {
//   final String title;
//   final String value;
//   const _StatBox({required this.title, required this.value});
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         margin: const EdgeInsets.only(right: 8),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: const Color(0xFFEFE4DE)),
//         ),
//         child: Column(
//           children: [
//             Text(title),
//             const SizedBox(height: 6),
//             Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
//           ],
//         ),
//       ),
//     );
//   }
// }
