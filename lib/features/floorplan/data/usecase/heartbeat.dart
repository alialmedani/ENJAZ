import 'package:enjaz/core/params/base_params.dart';
import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/core/usecase/usecase.dart';
import 'package:enjaz/features/floorplan/data/model/presence_model.dart';
import 'package:enjaz/features/floorplan/data/repo/floorplan_repository.dart';

/// POST /api/app/presence/heartbeat (no body).
class HeartbeatParam extends BaseParams {
  HeartbeatParam();
}

class HeartbeatUsecase extends UseCase<PresenceModel, HeartbeatParam> {
  final FloorplanRepository repository;
  HeartbeatUsecase(this.repository);

  @override
  Future<Result<PresenceModel>> call({required HeartbeatParam params}) {
    return repository.heartbeat();
  }
}
