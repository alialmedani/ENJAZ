// import 'package:flutter_bloc/flutter_bloc.dart';

// class CartItem {
//   final String drinkId;
//   final String title;
//   final String notes; // مثلاً الحجم: S/M/L
//   final int sugarLevel; // 0..3
//   final int qty;
//   final double unitPrice; // لو ما عندك سعر خليه 0

//   CartItem({
//     required this.drinkId,
//     required this.title,
//     required this.notes,
//     required this.sugarLevel,
//     required this.qty,
//     this.unitPrice = 0,
//   });

//   CartItem copyWith({int? qty}) => CartItem(
//     drinkId: drinkId,
//     title: title,
//     notes: notes,
//     sugarLevel: sugarLevel,
//     qty: qty ?? this.qty,
//     unitPrice: unitPrice,
//   );
// }

// class CartCubit extends Cubit<List<CartItem>> {
//   CartCubit() : super(const []);

//   void addItem(CartItem item) {
//     final list = List<CartItem>.from(state);
//     final i = list.indexWhere(
//       (e) =>
//           e.drinkId == item.drinkId &&
//           e.notes == item.notes &&
//           e.sugarLevel == item.sugarLevel,
//     );
//     if (i != -1) {
//       list[i] = list[i].copyWith(qty: list[i].qty + item.qty);
//     } else {
//       list.add(item);
//     }
//     emit(list);
//   }

//   void setQty(int index, int qty) {
//     final list = List<CartItem>.from(state);
//     if (index < 0 || index >= list.length) return;
//     list[index] = list[index].copyWith(qty: qty.clamp(1, 99));
//     emit(list);
//   }

//   void removeAt(int index) {
//     final list = List<CartItem>.from(state);
//     if (index < 0 || index >= list.length) return;
//     list.removeAt(index);
//     emit(list);
//   }

//   void clear() => emit(const []);
// }
