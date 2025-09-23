 import 'package:enjaz/features/officeboy/data/model/officeboy_model.dart';
import 'package:enjaz/features/officeboy/data/repo/office_boy_repo.dart';

import '../../../../core/boilerplate/pagination/models/get_list_request.dart';
import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';
 
class GetOrderOfficeBoyParams extends BaseParams {
  final GetListRequest? request;

  GetOrderOfficeBoyParams({required this.request});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (request != null) data.addAll(request!.toJson());
    return data;
  }
}

class GetOrderOfficeBoyUsecase extends UseCase<List<OfficeBoyModel>, GetOrderOfficeBoyParams> {
  late final OfficeBoyRepository repository;
  GetOrderOfficeBoyUsecase(this.repository);

  @override
  Future<Result<List<OfficeBoyModel>>> call({required GetOrderOfficeBoyParams params}) {
    return repository.requestGetOrderOfficeBoy(params: params);
  }
}
