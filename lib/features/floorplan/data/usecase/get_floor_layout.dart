import 'package:enjaz/core/params/base_params.dart';
import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/core/usecase/usecase.dart';
import 'package:enjaz/features/floorplan/data/model/floor_layout_model.dart';
import 'package:enjaz/features/floorplan/data/repo/floorplan_repository.dart';

class GetFloorLayoutParam extends BaseParams {
  final String floorId;

  GetFloorLayoutParam({required this.floorId});
}

class GetFloorLayoutUsecase
    extends UseCase<FloorLayoutModel, GetFloorLayoutParam> {
  final FloorplanRepository repository;
  GetFloorLayoutUsecase(this.repository);

  @override
  Future<Result<FloorLayoutModel>> call({required GetFloorLayoutParam params}) {
    return repository.getFloorLayout(params: params);
  }
}
