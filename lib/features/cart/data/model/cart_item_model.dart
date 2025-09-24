import 'package:enjaz/features/drink/data/model/drink_model.dart';

class CartItemModel {
  final DrinkModel drink;
  final int quantity;
  final String size;
  final double sugarPercentage;
  final String? notes;

  CartItemModel({
    required this.drink,
    required this.quantity,
    required this.size,
    required this.sugarPercentage,
    this.notes,
  });

  CartItemModel.fromJson(Map<String, dynamic> json)
    : drink = DrinkModel.fromJson(Map<String, dynamic>.from(json['drink'])),
      quantity = json['quantity'] ?? 1,
      size = json['size'] ?? 'M',
      sugarPercentage = (json['sugarPercentage'] ?? 0.5).toDouble(),
      notes = json['notes'];

  Map<String, dynamic> toJson() {
    return {
      'drink': drink.toJson(),
      'quantity': quantity,
      'size': size,
      'sugarPercentage': sugarPercentage,
      'notes': notes,
    };
  }

  CartItemModel copyWith({
    DrinkModel? drink,
    int? quantity,
    String? size,
    double? sugarPercentage,
    String? notes,
  }) {
    return CartItemModel(
      drink: drink ?? this.drink,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
      sugarPercentage: sugarPercentage ?? this.sugarPercentage,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemModel &&
          runtimeType == other.runtimeType &&
          drink.id == other.drink.id &&
          size == other.size &&
          sugarPercentage == other.sugarPercentage &&
          notes == other.notes;

  @override
  int get hashCode =>
      drink.id.hashCode ^
      size.hashCode ^
      sugarPercentage.hashCode ^
      notes.hashCode;
}
