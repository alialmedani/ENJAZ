// lib/features/order/data/model/order_model.dart
class OrderModel {
  final String? id;

  // لعرض السطر في الشاشة
  final String? itemName; // أو name / drinkName
  final String? size; // أو drinkSize
  final String? image; // أو imageUrl
  final int quantity;
  final double price;

  // حقول إضافية لو احتجتها
  final int? sugarLevel;
  final String? notes;
  final String? drinkId;
  final int? floor;
  final String? office;

  OrderModel({
    this.id,
    this.itemName,
    this.size,
    this.image,
    this.quantity = 1,
    this.price = 0.0,
    this.sugarLevel,
    this.notes,
    this.drinkId,
    this.floor,
    this.office,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // مساعدات آمنة للتحويل
    int _asInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    double _asDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is double) return v;
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0.0;
      return 0.0;
    }

    // لو البيانات متداخلة (مثلاً drink:{ name, image, price, size })
    final drink = json['drink'] is Map<String, dynamic>
        ? (json['drink'] as Map<String, dynamic>)
        : null;

    return OrderModel(
      id: json['id']?.toString(),
      itemName:
          (json['itemName'] ??
                  json['name'] ??
                  json['drinkName'] ??
                  drink?['name'])
              ?.toString(),
      size: (json['size'] ?? json['drinkSize'] ?? drink?['size'])?.toString(),
      image: (json['image'] ?? json['imageUrl'] ?? drink?['image'])?.toString(),
      quantity: _asInt(json['quantity']),
      price: _asDouble(json['price'] ?? drink?['price']),
      sugarLevel: json.containsKey('sugarLevel')
          ? _asInt(json['sugarLevel'])
          : null,
      notes: json['notes']?.toString(),
      drinkId: (json['drinkId'] ?? drink?['id'])?.toString(),
      floor: json['floor'] is int
          ? json['floor'] as int
          : int.tryParse('${json['floor'] ?? ''}'),
      office: json['office']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    if (itemName != null) 'itemName': itemName,
    if (size != null) 'size': size,
    if (image != null) 'image': image,
    'quantity': quantity,
    'price': price,
    if (sugarLevel != null) 'sugarLevel': sugarLevel,
    if (notes != null) 'notes': notes,
    if (drinkId != null) 'drinkId': drinkId,
    if (floor != null) 'floor': floor,
    if (office != null) 'office': office,
  };
}
