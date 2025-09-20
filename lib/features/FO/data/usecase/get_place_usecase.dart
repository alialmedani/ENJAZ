import 'package:enjaz/features/FO/data/model/place_model.dart';
import 'package:enjaz/features/FO/data/repo/place_repository.dart';

import '../../../../core/boilerplate/pagination/models/get_list_request.dart';
import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';

class GetPlaceParam extends BaseParams {
  final GetListRequest? request;

  String? floorId;
  int type;
  String? term;

  GetPlaceParam({
    required this.request,
    this.floorId,
    this.term,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (term != null && term!.isNotEmpty) data["term"] = term;
    if (floorId != null && floorId!.isNotEmpty) data["floorId"] = floorId;
    data["type"] = type;
    if (request != null) data.addAll(request!.toJson());

    return data;
  }
}

class GetPlacekUsecase extends UseCase<List<PlaceModel>, GetPlaceParam> {
  late final PlaceRepository repository;
  GetPlacekUsecase(this.repository);

  @override
  Future<Result<List<PlaceModel>>> call({required GetPlaceParam params}) {
    return repository.getPlace(params: params);
  }
}
