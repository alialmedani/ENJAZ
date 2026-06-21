import 'presence_model.dart';

/// DeskType integer enum mirroring the backend contract:
/// Desk = 1, Room = 2, Resource = 3.
enum DeskType {
  desk(1),
  room(2),
  resource(3);

  final int value;
  const DeskType(this.value);

  static DeskType fromValue(int? value) {
    switch (value) {
      case 2:
        return DeskType.room;
      case 3:
        return DeskType.resource;
      case 1:
      default:
        return DeskType.desk;
    }
  }
}

/// Mirrors backend `DeskDto`:
/// { id, floorId, label, type, x, y, assignedUserId?, assignedUserName?,
///   departmentId?, assignedUserStatus? (PresenceStatus) }
class DeskModel {
  String? id;
  String? floorId;
  String? label;
  int? type;
  int? x;
  int? y;
  String? assignedUserId;
  String? assignedUserName;
  String? departmentId;

  /// Presence status of the assigned user (PresenceStatus int), null when free.
  int? assignedUserStatus;

  DeskModel({
    this.id,
    this.floorId,
    this.label,
    this.type,
    this.x,
    this.y,
    this.assignedUserId,
    this.assignedUserName,
    this.departmentId,
    this.assignedUserStatus,
  });

  DeskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    floorId = json['floorId'];
    label = json['label'];
    type = json['type'];
    x = json['x'];
    y = json['y'];
    assignedUserId = json['assignedUserId'];
    assignedUserName = json['assignedUserName'];
    departmentId = json['departmentId'];
    assignedUserStatus = json['assignedUserStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['floorId'] = floorId;
    data['label'] = label;
    data['type'] = type;
    data['x'] = x;
    data['y'] = y;
    data['assignedUserId'] = assignedUserId;
    data['assignedUserName'] = assignedUserName;
    data['departmentId'] = departmentId;
    data['assignedUserStatus'] = assignedUserStatus;
    return data;
  }

  /// True when no user is assigned to this desk.
  bool get isFree => assignedUserId == null || assignedUserId!.isEmpty;

  DeskType get deskType => DeskType.fromValue(type);

  /// Presence status of the assigned user, or null when the desk is free.
  PresenceStatus? get presenceStatus =>
      isFree ? null : PresenceStatus.fromValue(assignedUserStatus);

  DeskModel copyWith({
    String? id,
    String? floorId,
    String? label,
    int? type,
    int? x,
    int? y,
    String? assignedUserId,
    String? assignedUserName,
    String? departmentId,
    int? assignedUserStatus,
    bool clearUser = false,
  }) {
    return DeskModel(
      id: id ?? this.id,
      floorId: floorId ?? this.floorId,
      label: label ?? this.label,
      type: type ?? this.type,
      x: x ?? this.x,
      y: y ?? this.y,
      assignedUserId: clearUser ? null : (assignedUserId ?? this.assignedUserId),
      assignedUserName:
          clearUser ? null : (assignedUserName ?? this.assignedUserName),
      departmentId: departmentId ?? this.departmentId,
      assignedUserStatus: clearUser
          ? null
          : (assignedUserStatus ?? this.assignedUserStatus),
    );
  }
}
