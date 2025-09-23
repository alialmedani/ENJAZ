class OfficeBoyModel {
  List<Items>? items;
  int? totalCount;

  OfficeBoyModel({items, totalCount});

  OfficeBoyModel.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    totalCount = json['totalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['totalCount'] = totalCount;
    return data;
  }
}

class Items {
  String? id;
  String? customerUserId;
  CustomerUser? customerUser;
  String? floorId;
  String? officeId;
  String? floorName;
  String? officeName;
  List<OrderItems>? orderItems;
  int? status;
  String? creationTime;

  Items({
    id,
    customerUserId,
    customerUser,
    floorId,
    officeId,
    floorName,
    officeName,
    orderItems,
    status,
    creationTime,
  });

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerUserId = json['customerUserId'];
    customerUser = json['customerUser'] != null
        ? new CustomerUser.fromJson(json['customerUser'])
        : null;
    floorId = json['floorId'];
    officeId = json['officeId'];
    floorName = json['floorName'];
    officeName = json['officeName'];
    if (json['orderItems'] != null) {
      orderItems = <OrderItems>[];
      json['orderItems'].forEach((v) {
        orderItems!.add(new OrderItems.fromJson(v));
      });
    }
    status = json['status'];
    creationTime = json['creationTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customerUserId'] = customerUserId;
    if (customerUser != null) {
      data['customerUser'] = customerUser!.toJson();
    }
    data['floorId'] = floorId;
    data['officeId'] = officeId;
    data['floorName'] = floorName;
    data['officeName'] = officeName;
    if (orderItems != null) {
      data['orderItems'] = orderItems!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['creationTime'] = creationTime;
    return data;
  }
}

class CustomerUser {
  String? id;
  String? creationTime;
  String? creatorId;
  String? lastModificationTime;
  String? lastModifierId;
  String? userName;
  String? email;
  String? name;
  String? surname;
  String? phoneNumber;
  bool? isActive;
  String? floorId;
  String? officeId;
  String? floorName;
  String? officeName;
  List<String>? roles;

  CustomerUser({
    id,
    creationTime,
    creatorId,
    lastModificationTime,
    lastModifierId,
    userName,
    email,
    name,
    surname,
    phoneNumber,
    isActive,
    floorId,
    officeId,
    floorName,
    officeName,
    roles,
  });

  CustomerUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    creationTime = json['creationTime'];
    creatorId = json['creatorId'];
    lastModificationTime = json['lastModificationTime'];
    lastModifierId = json['lastModifierId'];
    userName = json['userName'];
    email = json['email'];
    name = json['name'];
    surname = json['surname'];
    phoneNumber = json['phoneNumber'];
    isActive = json['isActive'];
    floorId = json['floorId'];
    officeId = json['officeId'];
    floorName = json['floorName'];
    officeName = json['officeName'];
    roles = json['roles'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['creationTime'] = creationTime;
    data['creatorId'] = creatorId;
    data['lastModificationTime'] = lastModificationTime;
    data['lastModifierId'] = lastModifierId;
    data['userName'] = userName;
    data['email'] = email;
    data['name'] = name;
    data['surname'] = surname;
    data['phoneNumber'] = phoneNumber;
    data['isActive'] = isActive;
    data['floorId'] = floorId;
    data['officeId'] = officeId;
    data['floorName'] = floorName;
    data['officeName'] = officeName;
    data['roles'] = roles;
    return data;
  }
}

class OrderItems {
  String? id;
  String? orderId;
  String? drinkId;
  Drink? drink;
  int? sugarLevel;
  int? quantity;
  String? notes;
  String? creationTime;

  OrderItems({
    id,
    orderId,
    drinkId,
    drink,
    sugarLevel,
    quantity,
    notes,
    creationTime,
  });

  OrderItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['orderId'];
    drinkId = json['drinkId'];
    drink = json['drink'] != null ? Drink.fromJson(json['drink']) : null;
    sugarLevel = json['sugarLevel'];
    quantity = json['quantity'];
    notes = json['notes'];
    creationTime = json['creationTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['orderId'] = orderId;
    data['drinkId'] = drinkId;
    if (drink != null) {
      data['drink'] = drink!.toJson();
    }
    data['sugarLevel'] = sugarLevel;
    data['quantity'] = quantity;
    data['notes'] = notes;
    data['creationTime'] = creationTime;
    return data;
  }
}

class Drink {
  String? id;
  String? name;
  String? nameAr;
  String? nameBe;
  String? description;

  Drink({id, name, nameAr, nameBe, description});

  Drink.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameAr = json['nameAr'];
    nameBe = json['nameBe'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['nameAr'] = nameAr;
    data['nameBe'] = nameBe;
    data['description'] = description;
    return data;
  }
}
