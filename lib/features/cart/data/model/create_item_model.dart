class CreateItemModel {
  final String drinkId;
  final int quantity;
  final int sugarLevel;
  final String notes;

  CreateItemModel({
    required this.drinkId,
    required this.quantity,
    required this.notes,
    required this.sugarLevel,
  });

  CreateItemModel.fromJson(Map<String, dynamic> json)
    : drinkId = json['drinkId'] ?? '',
      quantity = json['quantity'] ?? 1,
      notes = json['notes'] ?? '',
      sugarLevel = json['sugarLevel'] ?? 0;

  Map<String, dynamic> toJson() {
    return {
      'drinkId': drinkId,
      'quantity': quantity,
      'notes': notes,
      'sugarLevel': sugarLevel,
    };
  }
}
