class UserModel {
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

  UserModel({
    this.id,
    this.creationTime,
    this.creatorId,
    this.lastModificationTime,
    this.lastModifierId,
    this.userName,
    this.email,
    this.name,
    this.surname,
    this.phoneNumber,
    this.isActive,
    this.floorId,
    this.officeId,
    this.floorName,
    this.officeName,
    this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    creationTime: json['creationTime'],
    creatorId: json['creatorId'],
    lastModificationTime: json['lastModificationTime'],
    lastModifierId: json['lastModifierId'],
    userName: json['userName'],
    email: json['email'],
    name: json['name'],
    surname: json['surname'],
    phoneNumber: json['phoneNumber'],
    isActive: json['isActive'],
    floorId: json['floorId'],
    officeId: json['officeId'],
    floorName: json['floorName'],
    officeName: json['officeName'],
    roles: (json['roles'] as List?)?.map((e) => e.toString()).toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'creationTime': creationTime,
    'creatorId': creatorId,
    'lastModificationTime': lastModificationTime,
    'lastModifierId': lastModifierId,
    'userName': userName,
    'email': email,
    'name': name,
    'surname': surname,
    'phoneNumber': phoneNumber,
    'isActive': isActive,
    'floorId': floorId,
    'officeId': officeId,
    'floorName': floorName,
    'officeName': officeName,
    'roles': roles,
  };
}
