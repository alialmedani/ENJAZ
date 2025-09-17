import 'package:enjaz/features/drink/data/model/drink_model.dart';

class CartItemModel {
  final DrinkModel drink;
  final int quantity;
  final String size;
  final double sugarPercentage;

  CartItemModel({
    required this.drink,
    required this.quantity,
    required this.size,
    required this.sugarPercentage,
  });

  CartItemModel.fromJson(Map<String, dynamic> json)
    : drink = DrinkModel.fromJson(Map<String, dynamic>.from(json['drink'])),
      quantity = json['quantity'] ?? 1,
      size = json['size'] ?? 'M',
      sugarPercentage = (json['sugarPercentage'] ?? 0.5).toDouble();

  Map<String, dynamic> toJson() {
    return {
      'drink': drink.toJson(),
      'quantity': quantity,
      'size': size,
      'sugarPercentage': sugarPercentage,
    };
  }

  CartItemModel copyWith({
    DrinkModel? drink,
    int? quantity,
    String? size,
    double? sugarPercentage,
  }) {
    return CartItemModel(
      drink: drink ?? this.drink,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
      sugarPercentage: sugarPercentage ?? this.sugarPercentage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemModel &&
          runtimeType == other.runtimeType &&
          drink.id == other.drink.id &&
          size == other.size &&
          sugarPercentage == other.sugarPercentage;

  @override
  int get hashCode =>
      drink.id.hashCode ^ size.hashCode ^ sugarPercentage.hashCode;
}
