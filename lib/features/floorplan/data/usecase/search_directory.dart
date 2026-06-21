import 'package:enjaz/core/params/base_params.dart';
import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/core/usecase/usecase.dart';
import 'package:enjaz/features/floorplan/data/model/directory_item_model.dart';
import 'package:enjaz/features/floorplan/data/repo/floorplan_repository.dart';

/// Query for GET /api/app/directory/search :
/// { Text?, DepartmentId?, FloorId?, Type?, SkipCount?, MaxResultCount? }
class SearchDirectoryParam extends BaseParams {
  final String? text;
  final String? departmentId;
  final String? floorId;

  /// DirectoryItemType int (Person=1, Desk=2, Room=3, Resource=4).
  final int? type;
  final int skipCount;
  final int maxResultCount;

  SearchDirectoryParam({
    this.text,
    this.departmentId,
    this.floorId,
    this.type,
    this.skipCount = 0,
    this.maxResultCount = 20,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (text != null && text!.isNotEmpty) data['Text'] = text;
    if (departmentId != null && departmentId!.isNotEmpty) {
      data['DepartmentId'] = departmentId;
    }
    if (floorId != null && floorId!.isNotEmpty) data['FloorId'] = floorId;
    if (type != null) data['Type'] = type;
    data['SkipCount'] = skipCount;
    data['MaxResultCount'] = maxResultCount;
    return data;
  }
}

class SearchDirectoryUsecase
    extends UseCase<DirectorySearchResult, SearchDirectoryParam> {
  final FloorplanRepository repository;
  SearchDirectoryUsecase(this.repository);

  @override
  Future<Result<DirectorySearchResult>> call({
    required SearchDirectoryParam params,
  }) {
    return repository.searchDirectory(params: params);
  }
}
