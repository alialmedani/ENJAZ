/// PresenceStatus integer enum mirroring the backend contract:
/// Offline = 0, OnFloor = 1, AtDesk = 2, Away = 3.
enum PresenceStatus {
  offline(0),
  onFloor(1),
  atDesk(2),
  away(3);

  final int value;
  const PresenceStatus(this.value);

  static PresenceStatus fromValue(int? value) {
    switch (value) {
      case 1:
        return PresenceStatus.onFloor;
      case 2:
        return PresenceStatus.atDesk;
      case 3:
        return PresenceStatus.away;
      case 0:
      default:
        return PresenceStatus.offline;
    }
  }
}

/// Mirrors backend `PresenceDto`:
/// { id, userId, userName, status:int, floorId?, deskId?, lastSeen:datetime }
class PresenceModel {
  String? id;
  String? userId;
  String? userName;
  int? status;
  String? floorId;
  String? deskId;
  DateTime? lastSeen;

  PresenceModel({
    this.id,
    this.userId,
    this.userName,
    this.status,
    this.floorId,
    this.deskId,
    this.lastSeen,
  });

  PresenceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    userName = json['userName'];
    status = json['status'];
    floorId = json['floorId'];
    deskId = json['deskId'];
    lastSeen = json['lastSeen'] == null
        ? null
        : DateTime.tryParse(json['lastSeen'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['userName'] = userName;
    data['status'] = status;
    data['floorId'] = floorId;
    data['deskId'] = deskId;
    data['lastSeen'] = lastSeen?.toIso8601String();
    return data;
  }

  PresenceStatus get presenceStatus => PresenceStatus.fromValue(status);
}
