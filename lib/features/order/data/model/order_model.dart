import 'package:enjaz/features/drink/data/model/drink_model.dart';
import 'package:enjaz/features/profile/data/model/user_model.dart';

class OrderModel {
  String? customerUserId;
  UserModel? customerUser;
  String? floorId;
  String? officeId;
  List<OrderItems>? orderItems;
  int? status;
  String? creationTime;
  String? id;

  OrderModel({
    this.customerUserId,
    this.customerUser,
    this.floorId,
    this.officeId,
    this.orderItems,
    this.status,
    this.creationTime,
    this.id,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    customerUserId = json['customerUserId'];
    customerUser = json['customerUser'] != null
        ? UserModel.fromJson(json['customerUser'])
        : null;
    floorId = json['floorId'];
    officeId = json['officeId'];
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
    if (customerUser != null) {
      data['customerUser'] = customerUser!.toJson();
    }
    data['floorId'] = floorId;
    data['office'] = officeId;
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
  DrinkModel? drink;
  int? sugarLevel;
  int? quantity;
  String? notes;
  String? creationTime;
  String? id;

  OrderItems({
    this.orderId,
    this.drinkId,
    this.drink,
    this.sugarLevel,
    this.quantity,
    this.notes,
    this.creationTime,
    this.id,
  });

  OrderItems.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    drinkId = json['drinkId'];
    drink = json['drink'] != null ? DrinkModel.fromJson(json['drink']) : null;
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
    if (drink != null) {
      data['drink'] = drink!.toJson();
    }
    data['sugarLevel'] = sugarLevel;
    data['quantity'] = quantity;
    data['notes'] = notes;
    data['creationTime'] = creationTime;
    data['id'] = id;
    return data;
  }
}
