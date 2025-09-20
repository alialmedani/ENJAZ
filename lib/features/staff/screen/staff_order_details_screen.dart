// import 'package:easy_localization/easy_localization.dart';
// import 'package:enjaz/features/staff/cubit/staff_orders_cubit.dart';
// import 'package:enjaz/features/staff/data/model/staff_order.dart';
// import 'package:enjaz/features/staff/screen/widget/section.dart';
// import 'package:enjaz/features/staff/screen/widget/sla_countdown.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:enjaz/core/constant/app_colors/app_colors.dart';
// import 'package:enjaz/core/constant/text_styles/app_text_style.dart';
// import 'package:enjaz/core/constant/text_styles/font_size.dart';

// class StaffOrderDetailsScreen extends StatefulWidget {
//   final StaffOrder order;
//   const StaffOrderDetailsScreen({super.key, required this.order});
//   @override
//   State<StaffOrderDetailsScreen> createState() =>
//       _StaffOrderDetailsScreenState();
// }

// class _StaffOrderDetailsScreenState extends State<StaffOrderDetailsScreen> {
//   final _ctrl = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final o = widget.order;
//     final cubit = context.read<StaffOrdersCubit>();
//     return Scaffold(
//       backgroundColor: const Color(0xFFF6EDE7),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: AppColors.xprimaryColor,
//         title: Text(
//           'order_id'.tr(namedArgs: {'id': o.id}),
//           style: AppTextStyle.getBoldStyle(
//             fontSize: AppFontSize.size_16,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Container(
//             width: double.infinity,
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFFFE7E4B), Color(0xFFFFB56B)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Wrap(
//                   spacing: 8,
//                   runSpacing: 8,
//                   crossAxisAlignment: WrapCrossAlignment.center,
//                   children: [
//                     _chip(text: _statusLabel(o.status), icon: Icons.flag),
//                     if (o.scheduleType == ScheduleType.scheduled &&
//                         o.scheduledAt != null)
//                       _chip(
//                         text: 'scheduled_at'.tr(
//                           namedArgs: {'time': _fmtDateTime(o.scheduledAt)},
//                         ),
//                         icon: Icons.event,
//                       ),
//                     _chip(
//                       text: 'floor_office'.tr(
//                         namedArgs: {
//                           'floor': '${o.floor}',
//                           'office': '${o.office}',
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   'item_x_qty'.tr(
//                     namedArgs: {
//                       'name': o.itemName,
//                       'size': o.size,
//                       'qty': '${o.quantity}',
//                     },
//                   ),
//                   style: AppTextStyle.getBoldStyle(
//                     fontSize: AppFontSize.size_18,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 SlaCountdown.inHeader(dueAt: o.dueAt),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.all(16),
//               children: [
//                 Section(
//                   title: 'section_order_info'.tr(),
//                   child: Column(
//                     children: [
//                       InfoTile(
//                         title: 'info_sugar'.tr(),
//                         value: 'sugar_spoons'.tr(
//                           namedArgs: {'n': '${o.sugar}'},
//                         ),
//                       ),
//                       InfoTile(title: 'info_milk'.tr(), value: '${o.milkPct}%'),
//                       InfoTile(
//                         title: 'info_addons'.tr(),
//                         value: o.addons.isEmpty ? '-' : o.addons.join(', '),
//                       ),
//                       InfoTile(
//                         title: 'info_customer_note'.tr(),
//                         value: (o.customerNote ?? '-'),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Section(
//                   title: 'section_assignment'.tr(),
//                   child: Column(
//                     children: [
//                       InfoTile(
//                         title: 'info_status'.tr(),
//                         value: _statusLabel(o.status),
//                       ),
//                       InfoTile(
//                         title: 'info_assignee'.tr(),
//                         value: (o.assignee ?? '-'),
//                       ),
//                       if (o.scheduleType == ScheduleType.scheduled)
//                         InfoTile(
//                           title: 'info_scheduled_at'.tr(),
//                           value: _fmtDateTime(o.scheduledAt),
//                         ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Section(
//                   title: 'section_notes'.tr(),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       if (o.notes.isEmpty)
//                         Padding(
//                           padding: const EdgeInsets.all(12),
//                           child: Text(
//                             'empty_notes'.tr(),
//                             style: AppTextStyle.getRegularStyle(
//                               fontSize: AppFontSize.size_12,
//                               color: AppColors.secondPrimery,
//                             ),
//                           ),
//                         )
//                       else
//                         ...o.notes.reversed.map((n) => NoteTile(n)).toList(),
//                       const SizedBox(height: 8),
//                       NoteComposer(
//                         controller: _ctrl,
//                         hint: 'hint_add_note'.tr(),
//                         onSend: () {
//                           final txt = _ctrl.text;
//                           _ctrl.clear();
//                           cubit.addNote(o, 'Me', txt);
//                           setState(() {});
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   children: [
//                     if (o.assignee == null)
//                       OutlinedButton.icon(
//                         onPressed: () => setState(() => cubit.assignToMe(o)),
//                         icon: const Icon(Icons.assignment_ind_outlined),
//                         label: Text('btn_assign_to_me'.tr()),
//                       ),
//                     const Spacer(),
//                     if (o.status == StaffOrderStatus.pending)
//                       ElevatedButton(
//                         onPressed: () => setState(() => cubit.accept(o)),
//                         child: Text('btn_accept'.tr()),
//                       ),
//                     if (o.status == StaffOrderStatus.inProgress)
//                       ElevatedButton(
//                         onPressed: () => setState(() => cubit.markReady(o)),
//                         child: Text('btn_ready'.tr()),
//                       ),
//                     if (o.status == StaffOrderStatus.ready)
//                       ElevatedButton(
//                         onPressed: () => setState(() => cubit.markDelivered(o)),
//                         child: Text('btn_delivered'.tr()),
//                       ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _chip({required String text, IconData? icon}) => Container(
//     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//     decoration: BoxDecoration(
//       color: Colors.white.withOpacity(.18),
//       borderRadius: BorderRadius.circular(12),
//       border: Border.all(color: Colors.white.withOpacity(.35)),
//     ),
//     child: Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         if (icon != null) ...[
//           Icon(icon, size: 14, color: Colors.white),
//           const SizedBox(width: 6),
//         ],
//         Text(
//           text,
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ],
//     ),
//   );

//   String _fmtDateTime(DateTime? t) =>
//       t == null ? '-' : DateFormat('yyyy-MM-dd HH:mm').format(t);
//   String _statusLabel(StaffOrderStatus s) {
//     switch (s) {
//       case StaffOrderStatus.pending:
//         return 'status_pending'.tr();
//       case StaffOrderStatus.inProgress:
//         return 'status_in_progress'.tr();
//       case StaffOrderStatus.ready:
//         return 'status_ready'.tr();
//       case StaffOrderStatus.delivered:
//         return 'status_delivered'.tr();
//     }
//   }
// }
