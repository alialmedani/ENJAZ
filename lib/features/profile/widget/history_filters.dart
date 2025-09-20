// import 'package:flutter/material.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:enjaz/core/constant/app_colors/app_colors.dart';
// import 'segmented_tabs.dart';

// class HistoryFilters extends StatefulWidget {
//   final DateTime? selectedPrevMonth;
//   final ValueChanged<DateTime?> onSelectPrevMonth;
//   const HistoryFilters({
//     super.key,
//     required this.selectedPrevMonth,
//     required this.onSelectPrevMonth,
//   });

//   @override
//   State<HistoryFilters> createState() => _HistoryFiltersState();
// }

// class _HistoryFiltersState extends State<HistoryFilters>
//     with SingleTickerProviderStateMixin {
//   late final TabController _tabs;

//   @override
//   void initState() {
//     super.initState();
//     _tabs = TabController(length: 2, vsync: this)
//       ..addListener(() {
//         if (mounted) setState(() {});
//       });
//   }

//   @override
//   void dispose() {
//     _tabs.removeListener(() {});
//     _tabs.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         SegmentedTabs(
//           controller: _tabs,
//           tabs: ['this_month'.tr(), 'previous_months'.tr()],
//           backgroundColor: AppColors.white,
//           borderColor: const Color(0xFFEFE4DE),
//           pillGradient: [AppColors.darkAccentColor, AppColors.xorangeColor],
//           unselectedTextColor: AppColors.secondPrimery,
//           height: 46,
//           outerRadius: 12,
//           pillRadius: 8,
//           padding: const EdgeInsets.all(6),
//         ),
//         const SizedBox(height: 12),
//         if (_tabs.index == 1)
//           Row(
//             children: [
//               Expanded(
//                 child: OutlinedButton.icon(
//                   onPressed: () async {
//                     final now = DateTime.now();
//                     final first = DateTime(now.year, now.month - 11, 1);
//                     final picked = await showDatePicker(
//                       context: context,
//                       initialDate: now,
//                       firstDate: first,
//                       lastDate: now,
//                       helpText: 'pick_any_day_of_month'.tr(),
//                     );
//                     if (picked != null) {
//                       widget.onSelectPrevMonth(
//                         DateTime(picked.year, picked.month),
//                       );
//                     }
//                   },
//                   icon: const Icon(Icons.date_range),
//                   label: Text(
//                     widget.selectedPrevMonth == null
//                         ? 'pick_month'.tr()
//                         : DateFormat(
//                             'yyyy-MM',
//                           ).format(widget.selectedPrevMonth!),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               if (widget.selectedPrevMonth != null)
//                 IconButton(
//                   onPressed: () => widget.onSelectPrevMonth(null),
//                   icon: const Icon(Icons.clear),
//                   tooltip: 'clear'.tr(),
//                 ),
//             ],
//           ),
//       ],
//     );
//   }
// }
