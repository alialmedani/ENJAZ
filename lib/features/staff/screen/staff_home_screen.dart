// import 'package:easy_localization/easy_localization.dart';
// import 'package:enjaz/features/staff/cubit/staff_orders_cubit.dart';
//  import 'package:enjaz/features/staff/screen/widget/my_orders_tab.dart';
// import 'package:enjaz/features/staff/screen/widget/queue_tab.dart';
// import 'package:enjaz/features/staff/screen/widget/scheduled_tab.dart';
// import 'package:enjaz/features/staff/screen/widget/staff_header.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class StaffHomeScreen extends StatefulWidget {
//   const StaffHomeScreen({super.key});
//   @override
//   State<StaffHomeScreen> createState() => _StaffHomeScreenState();
// }

// class _StaffHomeScreenState extends State<StaffHomeScreen>
//     with SingleTickerProviderStateMixin {
//   late final TabController _tabs;
//   @override
//   void initState() {
//     super.initState();
//     _tabs = TabController(length: 4, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabs.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => StaffOrdersCubit(),
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF6EDE7),
//         body: Column(
//           children: [
//             StaffHeader(title: 'staff_title'.tr(), controller: _tabs),
//             Expanded(
//               child: TabBarView(
//                 controller: _tabs,
//                 children: const [
//                   QueueTab(),
//                   ScheduledTab(),
//                   MyOrdersTab(),
//                   StaffProfileTabLight(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
