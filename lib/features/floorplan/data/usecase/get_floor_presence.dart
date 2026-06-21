import 'package:enjaz/core/params/base_params.dart';
import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/core/usecase/usecase.dart';
import 'package:enjaz/features/floorplan/data/model/presence_model.dart';
import 'package:enjaz/features/floorplan/data/repo/floorplan_repository.dart';

/// GET /api/app/presence/floor/{floorId}
class GetFloorPresenceParam extends BaseParams {
  final String floorId;

  GetFloorPresenceParam({required this.floorId});
}

class GetFloorPresenceUsecase
    extends UseCase<List<PresenceModel>, GetFloorPresenceParam> {
  final FloorplanRepository repository;
  GetFloorPresenceUsecase(this.repository);

  @override
  Future<Result<List<PresenceModel>>> call({
    required GetFloorPresenceParam params,
  }) {
    return repository.getFloorPresence(params: params);
  }
}
