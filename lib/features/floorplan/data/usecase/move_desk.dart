import 'package:enjaz/core/params/base_params.dart';
import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/core/usecase/usecase.dart';
import 'package:enjaz/features/floorplan/data/model/desk_model.dart';
import 'package:enjaz/features/floorplan/data/repo/floorplan_repository.dart';

/// Body for POST /api/app/desk/move : { deskId, x, y }
class MoveDeskParam extends BaseParams {
  final String deskId;
  final int x;
  final int y;

  MoveDeskParam({required this.deskId, required this.x, required this.y});

  Map<String, dynamic> toJson() => {'deskId': deskId, 'x': x, 'y': y};
}

class MoveDeskUsecase extends UseCase<DeskModel, MoveDeskParam> {
  final FloorplanRepository repository;
  MoveDeskUsecase(this.repository);

  @override
  Future<Result<DeskModel>> call({required MoveDeskParam params}) {
    return repository.moveDesk(params: params);
  }
}
