import 'package:enjaz/features/drink/data/model/drink_model.dart';

import '../../../../core/boilerplate/pagination/models/get_list_request.dart';
import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/drink_repository.dart';

class GetAllDrinkParams extends BaseParams {
  final GetListRequest? request;

  GetAllDrinkParams({required this.request});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (request != null) data.addAll(request!.toJson());
    return data;
  }
}

class GetAllDrinkUsecase extends UseCase<List<DrinkModel>, GetAllDrinkParams> {
  late final DrinkRepository repository;
  GetAllDrinkUsecase(this.repository);

  @override
  Future<Result<List<DrinkModel>>> call({required GetAllDrinkParams params}) {
    return repository.requestAllDrink(params: params);
  }
}
