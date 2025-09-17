
class OrderHistoryEntry {
  final DateTime createdAt;
  final int quantity;
  final double unitPrice; 
  final double extrasPrice;

  const OrderHistoryEntry({
    required this.createdAt,
    this.quantity = 1,
    this.unitPrice = 0,
    this.extrasPrice = 0,
  });

  double get totalPrice => (unitPrice + extrasPrice) * quantity;
}
