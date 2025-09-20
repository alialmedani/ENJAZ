class RegisterModel {
  String? userName;
  String? name;
  String? phoneNumber;
  List<String>? roles;
  String? password;
  String? floorId;
  String? officeId;

  RegisterModel({
    this.userName,
    this.name,
    this.phoneNumber,
    this.roles,
    this.password,
    this.floorId,
    this.officeId,
  });

  RegisterModel.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    roles = json['roles'].cast<String>();
    password = json['password'];
    floorId = json['floorId'];
    officeId = json['officeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userName'] = userName;
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    data['roles'] = roles;
    data['password'] = password;
    data['floorId'] = floorId;
    data['officeId'] = officeId;
    return data;
  }
}
