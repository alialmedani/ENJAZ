// // lib/features/staff/widgets/section.dart
// import 'package:enjaz/features/staff/cubit/ccubit1.dart';
// import 'package:flutter/material.dart';

// class Section extends StatelessWidget {
//   final String title;
//   final Widget child;
//   const Section({super.key, required this.title, required this.child});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.04),
//             blurRadius: 10,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
//           const SizedBox(height: 10),
//           child,
//         ],
//       ),
//     );
//   }
// }
// class InfoTile extends StatelessWidget {
//   final String title;
//   final String value;
//   const InfoTile({super.key, required this.title, required this.value});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFEFE4DE)),
//       ),
//       child: Row(
//         children: [
//           Text(title),
//           const Spacer(),
//           Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
//         ],
//       ),
//     );
//   }
// }
// class NoteComposer extends StatelessWidget {
//   final TextEditingController controller;
//   final VoidCallback onSend;
//   final String hint;
//   const NoteComposer({
//     super.key,
//     required this.controller,
//     required this.onSend,
//     required this.hint,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFEFE4DE)),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: controller,
//               decoration: InputDecoration(
//                 hintText: hint,
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//           IconButton(onPressed: onSend, icon: const Icon(Icons.send)),
//         ],
//       ),
//     );
//   }
// }
// class NoteTile extends StatelessWidget {
//   final OrderNote n;
//   const NoteTile(this.n, {super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.02),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Icon(Icons.comment, size: 18, color: Colors.orange),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       n.author,
//                       style: const TextStyle(fontWeight: FontWeight.w700),
//                     ),
//                     const Spacer(),
//                     Text(_fmt(n.time), style: const TextStyle(fontSize: 12)),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 Text(n.text),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _fmt(DateTime t) =>
//       '${t.year}-${t.month.toString().padLeft(2, '0')}-${t.day.toString().padLeft(2, '0')} ${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
// }
// class EmptyView extends StatelessWidget {
//   final String message;
//   const EmptyView({super.key, required this.message});
//   @override
//   Widget build(BuildContext context) => Center(
//     child: Padding(padding: const EdgeInsets.all(24), child: Text(message)),
//   );
// }
