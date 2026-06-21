import 'package:enjaz/core/params/base_params.dart';
import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/core/usecase/usecase.dart';
import 'package:enjaz/features/floorplan/data/model/desk_model.dart';
import 'package:enjaz/features/floorplan/data/repo/floorplan_repository.dart';

/// Body for POST /api/app/desk/assign-user : { deskId, userId? }
/// A null [userId] clears the seat.
class AssignUserToDeskParam extends BaseParams {
  final String deskId;
  final String? userId;

  AssignUserToDeskParam({required this.deskId, this.userId});

  Map<String, dynamic> toJson() => {'deskId': deskId, 'userId': userId};
}

class AssignUserToDeskUsecase
    extends UseCase<DeskModel, AssignUserToDeskParam> {
  final FloorplanRepository repository;
  AssignUserToDeskUsecase(this.repository);

  @override
  Future<Result<DeskModel>> call({required AssignUserToDeskParam params}) {
    return repository.assignUserToDesk(params: params);
  }
}
