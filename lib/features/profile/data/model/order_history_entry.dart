// lib/features/profile/data/model/order_history_entry.dart
import 'package:enjaz/features/order/data/model/order_model.dart';

class OrderHistoryEntry {
  final OrderModel order;
  final DateTime createdAt;
  final int quantity;
  final double unitPrice; // سعر الكوب حسب الحجم
  final double extrasPrice; // سعر الإضافات (إن وُجد)

  const OrderHistoryEntry({
    required this.order,
    required this.createdAt,
    this.quantity = 1,
    this.unitPrice = 0,
    this.extrasPrice = 0,
  });

  double get totalPrice => (unitPrice + extrasPrice) * quantity;
}
