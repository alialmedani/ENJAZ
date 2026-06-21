import 'package:enjaz/core/params/base_params.dart';
import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/core/usecase/usecase.dart';
import 'package:enjaz/features/floorplan/data/model/directory_item_model.dart';
import 'package:enjaz/features/floorplan/data/repo/floorplan_repository.dart';

/// Query for GET /api/app/department/autocomplete : { term? }
class DepartmentAutocompleteParam extends BaseParams {
  final String? term;

  DepartmentAutocompleteParam({this.term});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (term != null && term!.isNotEmpty) data['term'] = term;
    return data;
  }
}

class DepartmentAutocompleteUsecase
    extends UseCase<List<DepartmentItemModel>, DepartmentAutocompleteParam> {
  final FloorplanRepository repository;
  DepartmentAutocompleteUsecase(this.repository);

  @override
  Future<Result<List<DepartmentItemModel>>> call({
    required DepartmentAutocompleteParam params,
  }) {
    return repository.departmentAutocomplete(params: params);
  }
}
