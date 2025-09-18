class UserModel {
  String? userName;
  String? email;
  String? name;
  String? surname;
  String? phoneNumber;
  bool? isActive;
  int? floor;
  String? office;
  List<String>? roles;
  String? creationTime;
  String? creatorId;
  String? id;

  UserModel(
      {this.userName,
      this.email,
      this.name,
      this.surname,
      this.phoneNumber,
      this.isActive,
      this.floor,
      this.office,
      this.roles,
      this.creationTime,
      this.creatorId,
      this.id});

  UserModel.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    email = json['email'];
    name = json['name'];
    surname = json['surname'];
    phoneNumber = json['phoneNumber'];
    isActive = json['isActive'];
    floor = json['floor'];
    office = json['office'];
    roles = json['roles'].cast<String>();
    creationTime = json['creationTime'];
    creatorId = json['creatorId'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userName'] = userName;
    data['email'] = email;
    data['name'] = name;
    data['surname'] = surname;
    data['phoneNumber'] = phoneNumber;
    data['isActive'] = isActive;
    data['floor'] = floor;
    data['office'] = office;
    data['roles'] = roles;
    data['creationTime'] = creationTime;
    data['creatorId'] = creatorId;
    data['id'] = id;
    return data;
  }
}

