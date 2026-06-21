import 'presence_model.dart';

/// DirectoryItemType integer enum mirroring the backend contract:
/// Person = 1, Desk = 2, Room = 3, Resource = 4.
enum DirectoryItemType {
  person(1),
  desk(2),
  room(3),
  resource(4);

  final int value;
  const DirectoryItemType(this.value);

  static DirectoryItemType fromValue(int? value) {
    switch (value) {
      case 2:
        return DirectoryItemType.desk;
      case 3:
        return DirectoryItemType.room;
      case 4:
        return DirectoryItemType.resource;
      case 1:
      default:
        return DirectoryItemType.person;
    }
  }
}

/// Mirrors backend `DirectoryItemDto`:
/// { itemType:int, id, name, floorId?, floorName?, deskId?, deskLabel?,
///   departmentId?, departmentName?, presenceStatus?, x?, y? }
class DirectoryItemModel {
  int? itemType;
  String? id;
  String? name;
  String? floorId;
  String? floorName;
  String? deskId;
  String? deskLabel;
  String? departmentId;
  String? departmentName;
  int? presenceStatus;
  int? x;
  int? y;

  DirectoryItemModel({
    this.itemType,
    this.id,
    this.name,
    this.floorId,
    this.floorName,
    this.deskId,
    this.deskLabel,
    this.departmentId,
    this.departmentName,
    this.presenceStatus,
    this.x,
    this.y,
  });

  DirectoryItemModel.fromJson(Map<String, dynamic> json) {
    itemType = json['itemType'];
    id = json['id'];
    name = json['name'];
    floorId = json['floorId'];
    floorName = json['floorName'];
    deskId = json['deskId'];
    deskLabel = json['deskLabel'];
    departmentId = json['departmentId'];
    departmentName = json['departmentName'];
    presenceStatus = json['presenceStatus'];
    x = json['x'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['itemType'] = itemType;
    data['id'] = id;
    data['name'] = name;
    data['floorId'] = floorId;
    data['floorName'] = floorName;
    data['deskId'] = deskId;
    data['deskLabel'] = deskLabel;
    data['departmentId'] = departmentId;
    data['departmentName'] = departmentName;
    data['presenceStatus'] = presenceStatus;
    data['x'] = x;
    data['y'] = y;
    return data;
  }

  DirectoryItemType get type => DirectoryItemType.fromValue(itemType);

  /// Presence status when this item is a person carrying one; otherwise null.
  PresenceStatus? get presence =>
      presenceStatus == null ? null : PresenceStatus.fromValue(presenceStatus);

  bool get hasFloor => floorId != null && floorId!.isNotEmpty;
}

/// Wraps the paged result `{ totalCount, items: DirectoryItemDto[] }`.
class DirectorySearchResult {
  final int totalCount;
  final List<DirectoryItemModel> items;

  DirectorySearchResult({this.totalCount = 0, this.items = const []});

  DirectorySearchResult.fromJson(Map<String, dynamic> json)
    : totalCount = json['totalCount'] ?? 0,
      items = json['items'] == null
          ? <DirectoryItemModel>[]
          : List<DirectoryItemModel>.from(
              (json['items'] as List).map(
                (x) => DirectoryItemModel.fromJson(x),
              ),
            );
}

/// Mirrors a department autocomplete entry: { id, name }.
class DepartmentItemModel {
  String? id;
  String? name;

  DepartmentItemModel({this.id, this.name});

  DepartmentItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
