// // lib/features/order/data/datasource/order_static_data_source.dart
// import 'dart:math';
// import 'package:enjaz/features/order/data/model/params/create_order_params.dart';
// import 'package:enjaz/features/order/data/model/order_model.dart';
 
// abstract class IOrderStaticDataSource {
//   Future<List<OrderModel>> getOrders();
//   Future<OrderModel> createOrder(CreateOrderParams params);
// }

// class OrderStaticDataSource implements IOrderStaticDataSource {
//   // Seed static data (in-memory)
//   static final List<OrderModel> _orders = [
//     OrderModel(
//       id: 'ord_1',
//       itemName: 'Cappuccino',
//       size: 'M',
//        floor: 2,
//      ),
//     OrderModel(
//       id: 'ord_2',
//       itemName: 'Latte',
//       size: 'L',
//        floor: 3,
//      ),
//     OrderModel(
//       id: 'ord_3',
//       itemName: 'Espresso',
//       size: 'S',
//        floor: 1,
//       ),
//     OrderModel(
//       id: 'ord_4',
//       itemName: 'Mocha',
//       size: 'M',
//        floor: 5,
//      ),
//   ];

//   @override
//   Future<List<OrderModel>> getOrders() async {
//     // محاكاة شبكة
//     await Future.delayed(const Duration(milliseconds: 350));
//     // NOTE: في نسخة API حقيقية، ستعود الحالة من الخادم.
//     return List<OrderModel>.from(_orders);
//   }

//   @override
//   Future<OrderModel> createOrder(CreateOrderParams p) async {
//     await Future.delayed(const Duration(milliseconds: 350));

//     if (p.itemName.trim().isEmpty) throw Exception('INVALID_ITEM');
//     if (!['S', 'M', 'L'].contains(p.size)) throw Exception('INVALID_SIZE');
//     if (p.buyerName.trim().isEmpty) throw Exception('INVALID_BUYER');
//     if (p.floor < 1 || p.floor > 5) throw Exception('INVALID_FLOOR');
//     if (p.office < 1 || p.office > 6) throw Exception('INVALID_OFFICE');

//     final id = 'ord_${Random().nextInt(999999)}';
//     final model = OrderModel(
//       id: id,
//       itemName: p.itemName.trim(),
//       size: p.size,
//        floor: p.floor,
//      );
//     _orders.insert(0, model);
//     return model;
//   }
// }
