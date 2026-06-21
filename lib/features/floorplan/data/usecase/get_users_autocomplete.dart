import 'package:enjaz/core/params/base_params.dart';
import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/core/usecase/usecase.dart';
import 'package:enjaz/features/floorplan/data/model/desk_user_model.dart';
import 'package:enjaz/features/floorplan/data/repo/floorplan_repository.dart';

/// Query for GET /api/app/user/autocomplete : { term? }
class GetUsersAutocompleteParam extends BaseParams {
  final String? term;

  GetUsersAutocompleteParam({this.term});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (term != null && term!.isNotEmpty) data['term'] = term;
    return data;
  }
}

class GetUsersAutocompleteUsecase
    extends UseCase<List<DeskUserModel>, GetUsersAutocompleteParam> {
  final FloorplanRepository repository;
  GetUsersAutocompleteUsecase(this.repository);

  @override
  Future<Result<List<DeskUserModel>>> call({
    required GetUsersAutocompleteParam params,
  }) {
    return repository.getUsersAutocomplete(params: params);
  }
}
