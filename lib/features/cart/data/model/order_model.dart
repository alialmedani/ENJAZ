class OrderModel {
  String? customerUserId;
  int? floor;
  String? office;
  List<OrderItems>? orderItems;
  int? status;
  String? creationTime;
  String? id;

  OrderModel(
      {this.customerUserId,
      this.floor,
      this.office,
      this.orderItems,
      this.status,
      this.creationTime,
      this.id});

  OrderModel.fromJson(Map<String, dynamic> json) {
    customerUserId = json['customerUserId'];
    floor = json['floor'];
    office = json['office'];
    if (json['orderItems'] != null) {
      orderItems = <OrderItems>[];
      json['orderItems'].forEach((v) {
        orderItems!.add(OrderItems.fromJson(v));
      });
    }
    status = json['status'];
    creationTime = json['creationTime'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerUserId'] = customerUserId;
    data['floor'] = floor;
    data['office'] = office;
    if (orderItems != null) {
      data['orderItems'] = orderItems!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['creationTime'] = creationTime;
    data['id'] = id;
    return data;
  }
}

class OrderItems {
  String? orderId;
  String? drinkId;
  int? sugarLevel;
  int? quantity;
  String? notes;
  String? creationTime;
  String? id;

  OrderItems(
      {this.orderId,
      this.drinkId,
      this.sugarLevel,
      this.quantity,
      this.notes,
      this.creationTime,
      this.id});

  OrderItems.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    drinkId = json['drinkId'];
    sugarLevel = json['sugarLevel'];
    quantity = json['quantity'];
    notes = json['notes'];
    creationTime = json['creationTime'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderId'] = orderId;
    data['drinkId'] = drinkId;
    data['sugarLevel'] = sugarLevel;
    data['quantity'] = quantity;
    data['notes'] = notes;
    data['creationTime'] = creationTime;
    data['id'] = id;
    return data;
  }
}