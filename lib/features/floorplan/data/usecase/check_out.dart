import 'package:enjaz/core/params/base_params.dart';
import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/core/usecase/usecase.dart';
import 'package:enjaz/features/floorplan/data/model/presence_model.dart';
import 'package:enjaz/features/floorplan/data/repo/floorplan_repository.dart';

/// POST /api/app/presence/check-out (no body).
class CheckOutParam extends BaseParams {
  CheckOutParam();
}

class CheckOutUsecase extends UseCase<PresenceModel, CheckOutParam> {
  final FloorplanRepository repository;
  CheckOutUsecase(this.repository);

  @override
  Future<Result<PresenceModel>> call({required CheckOutParam params}) {
    return repository.checkOut();
  }
}
