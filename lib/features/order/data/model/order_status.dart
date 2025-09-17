// // lib/features/order/data/model/order_status.dart
// enum OrderStatus { pending, ready, done }

// extension OrderStatusX on OrderStatus {
//   String get ar {
//     switch (this) {
//       case OrderStatus.pending:
//         return 'قيد التنفيذ';
//       case OrderStatus.ready:
//         return 'جاهز';
//       case OrderStatus.done:
//         return 'تم';
//     }
//   }

//   String get value {
//     switch (this) {
//       case OrderStatus.pending:
//         return 'pending';
//       case OrderStatus.ready:
//         return 'ready';
//       case OrderStatus.done:
//         return 'done';
//     }
//   }

//   static OrderStatus parse(String? s) {
//     switch ((s ?? '').toLowerCase()) {
//       case 'ready':
//         return OrderStatus.ready;
//       case 'done':
//         return OrderStatus.done;
//       case 'pending':
//       default:
//         return OrderStatus.pending;
//     }
//   }
// }
