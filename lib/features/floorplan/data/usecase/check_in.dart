import 'package:enjaz/core/params/base_params.dart';
import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/core/usecase/usecase.dart';
import 'package:enjaz/features/floorplan/data/model/presence_model.dart';
import 'package:enjaz/features/floorplan/data/repo/floorplan_repository.dart';

/// Body for POST /api/app/presence/check-in : { floorId?, deskId? }
class CheckInParam extends BaseParams {
  final String? floorId;
  final String? deskId;

  CheckInParam({this.floorId, this.deskId});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (floorId != null && floorId!.isNotEmpty) data['floorId'] = floorId;
    if (deskId != null && deskId!.isNotEmpty) data['deskId'] = deskId;
    return data;
  }
}

class CheckInUsecase extends UseCase<PresenceModel, CheckInParam> {
  final FloorplanRepository repository;
  CheckInUsecase(this.repository);

  @override
  Future<Result<PresenceModel>> call({required CheckInParam params}) {
    return repository.checkIn(params: params);
  }
}
