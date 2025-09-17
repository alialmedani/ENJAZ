class CoffeeApiModel {
  final String id; // UUID/ID للعنصر
  final String name;
  final String description;
  final double price; // من السيرفر (قد يجي int أو String)
  final String type; // إن وُجد
  final String imageId; // FileId للصورة في DMS

  CoffeeApiModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.type,
    required this.imageId,
  });

  factory CoffeeApiModel.fromJson(Map<String, dynamic> json) {
    double _asDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0.0;
      return 0.0;
    }

    return CoffeeApiModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: _asDouble(json['price']),
      type: (json['type'] ?? json['category'] ?? '').toString(),
      imageId: (json['imageId'] ?? json['fileId'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'price': price,
    'type': type,
    'imageId': imageId,
  };
}
