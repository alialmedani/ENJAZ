import 'desk_model.dart';

/// Mirrors backend `FloorLayoutDto`:
/// { floorId, floorName, floorPlanImageId?, planWidth?, planHeight?, desks[] }
class FloorLayoutModel {
  String? floorId;
  String? floorName;
  String? floorPlanImageId;
  int? planWidth;
  int? planHeight;
  List<DeskModel> desks;

  FloorLayoutModel({
    this.floorId,
    this.floorName,
    this.floorPlanImageId,
    this.planWidth,
    this.planHeight,
    this.desks = const [],
  });

  FloorLayoutModel.fromJson(Map<String, dynamic> json)
    : desks = json['desks'] == null
          ? <DeskModel>[]
          : List<DeskModel>.from(
              (json['desks'] as List).map((x) => DeskModel.fromJson(x)),
            ) {
    floorId = json['floorId'];
    floorName = json['floorName'];
    floorPlanImageId = json['floorPlanImageId'];
    planWidth = json['planWidth'];
    planHeight = json['planHeight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['floorId'] = floorId;
    data['floorName'] = floorName;
    data['floorPlanImageId'] = floorPlanImageId;
    data['planWidth'] = planWidth;
    data['planHeight'] = planHeight;
    data['desks'] = desks.map((x) => x.toJson()).toList();
    return data;
  }

  bool get hasPlanImage =>
      floorPlanImageId != null && floorPlanImageId!.isNotEmpty;

  FloorLayoutModel copyWith({
    String? floorId,
    String? floorName,
    String? floorPlanImageId,
    int? planWidth,
    int? planHeight,
    List<DeskModel>? desks,
  }) {
    return FloorLayoutModel(
      floorId: floorId ?? this.floorId,
      floorName: floorName ?? this.floorName,
      floorPlanImageId: floorPlanImageId ?? this.floorPlanImageId,
      planWidth: planWidth ?? this.planWidth,
      planHeight: planHeight ?? this.planHeight,
      desks: desks ?? this.desks,
    );
  }
}
