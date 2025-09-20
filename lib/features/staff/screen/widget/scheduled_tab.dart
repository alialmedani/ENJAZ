// // lib/features/staff/widgets/scheduled_tab.dart
// import 'package:easy_localization/easy_localization.dart';
// import 'package:enjaz/features/profile/screen/widget/fade_slide_in.dart';
// import 'package:enjaz/features/staff/cubit/ccubit1.dart';
// import 'package:enjaz/features/staff/cubit/staff_orders_cubit.dart';
// import 'package:enjaz/features/staff/data/model/staff_order.dart' show StaffOrderStatus, ScheduleType;
// import 'package:enjaz/features/staff/screen/staff_order_details_screen.dart';
// import 'package:enjaz/features/staff/screen/widget/section.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:enjaz/core/constant/app_colors/app_colors.dart';
 
//  import 'quick_bar.dart';
//  import 'status_pill.dart';
 
// class ScheduledTab extends StatefulWidget {
//   const ScheduledTab({super.key});
//   @override
//   State<ScheduledTab> createState() => _ScheduledTabState();
// }

// class _ScheduledTabState extends State<ScheduledTab> {
//   String _search = '';

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<StaffOrdersCubit, StaffOrdersState>(
//       builder: (context, st) {
//         final now = DateTime.now();
//         final list =
//             st.all
//                 .where((o) => o.scheduleType == ScheduleType.scheduled)
//                 .where(
//                   (o) =>
//                       _search.isEmpty ||
//                       o.itemName.toLowerCase().contains(
//                         _search.toLowerCase(),
//                       ) ||
//                       o.id.toLowerCase().contains(_search.toLowerCase()),
//                 )
//                 .toList()
//               ..sort(
//                 (a, b) =>
//                     (a.scheduledAt ?? now).compareTo(b.scheduledAt ?? now),
//               );

//         return Column(
//           children: [
//             QuickBar(
//               placeholder: 'search_scheduled_placeholder'.tr(),
//               onChanged: (v) => setState(() => _search = v),
//               onRefresh: () => context.read<StaffOrdersCubit>().refresh(),
//             ),
//             Expanded(
//               child: st.loading
//                   ? Center(
//                       child: CircularProgressIndicator(
//                         color: AppColors.xprimaryColor,
//                       ),
//                     )
//                   : list.isEmpty
//                   ? EmptyView(message: 'empty_scheduled'.tr())
//                   : ListView.separated(
//                       padding: const EdgeInsets.all(16),
//                       physics: const BouncingScrollPhysics(),
//                       itemCount: list.length,
//                       separatorBuilder: (_, __) => const SizedBox(height: 12),
//                       itemBuilder: (_, i) {
//                         final o = list[i];
//                         final minutesLeft = o.scheduledAt?.difference(now).inMinutes;
//                         final showWarn =
//                             minutesLeft != null &&
//                             minutesLeft <= 10 &&
//                             minutesLeft >= 0;

//                         return FadeSlideIn(
//                           delay: Duration(milliseconds: 60 * i),
//                           child: Container(
//                             padding: const EdgeInsets.all(14),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(14),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(.06),
//                                   blurRadius: 12,
//                                   offset: const Offset(0, 6),
//                                 ),
//                               ],
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Text(
//                                         'item_x_qty'.tr(
//                                           namedArgs: {
//                                             'name': o.itemName,
//                                             'size': o.size,
//                                             'qty': '${o.quantity}',
//                                           },
//                                         ),
//                                       ),
//                                     ),
//                                     StatusPill(
//                                       status: o.status,
//                                       scheduled: true,
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 6),
//                                 Text(
//                                   'scheduled_at'.tr(
//                                     namedArgs: {
//                                       'time': DateFormat(
//                                         'yyyy-MM-dd HH:mm',
//                                       ).format(o.scheduledAt ?? now),
//                                     },
//                                   ),
//                                 ),
//                                 Text(
//                                   'floor_office'.tr(
//                                     namedArgs: {
//                                       'floor': '${o.floor}',
//                                       'office': '${o.office}',
//                                     },
//                                   ),
//                                 ),
//                                 if (showWarn) ...[
//                                   const SizedBox(height: 8),
//                                   Row(
//                                     children: [
//                                       const Icon(
//                                         Icons.notifications_active,
//                                         color: Colors.orange,
//                                         size: 18,
//                                       ),
//                                       const SizedBox(width: 6),
//                                       Text(
//                                         'scheduled_in_min'.tr(
//                                           namedArgs: {
//                                             'min': '${minutesLeft.abs()}',
//                                           },
//                                         ),
//                                         style: const TextStyle(
//                                           color: Colors.orange,
//                                           fontWeight: FontWeight.w700,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                                 const SizedBox(height: 10),
//                                 Row(
//                                   children: [
//                                     if (o.status == StaffOrderStatus.pending)
//                                       TextButton(
//                                         onPressed: () => context
//                                             // .read<StaffOrdersCubit>()
//                                             // .accept(o),
//                                         ,child: Text('btn_accept'.tr()),
//                                       ),
//                                     if (o.status == StaffOrderStatus.inProgress)
//                                       TextButton(
//                                         onPressed: () => context
//                                             // .read<StaffOrdersCubit>()
//                                             // .markReady(o),
//                                       ,  child: Text('btn_ready'.tr()),
//                                       ),
//                                     if (o.status == StaffOrderStatus.ready)
//                                       TextButton(
//                                         onPressed: () => context
//                                             // .read<StaffOrdersCubit>()
//                                             // .markDelivered(o),,
//                                       ,  child: Text('btn_delivered'.tr()),
//                                       ),
//                                     const Spacer(),
//                                     // OutlinedButton.icon(
//                                     //   onPressed: () =>
//                                     //       Navigator.of(context).push(
//                                     //         // MaterialPageRoute(
//                                     //         //   builder: (_) =>
//                                     //         //       StaffOrderDetailsScreen(
//                                     //         //         order: o,
//                                     //         //       ),
//                                     //         // ),
//                                     //       ),
//                                     //   icon: const Icon(Icons.description),
//                                     //   label: Text('btn_details'.tr()),
//                                     // ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
