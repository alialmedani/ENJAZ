import 'package:enjaz/features/order/data/model/order_model.dart';
import '../../../../core/boilerplate/pagination/models/get_list_request.dart';
import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/order_repo.dart';

class GetAllOrdersParams extends BaseParams {
  final GetListRequest? request;

  GetAllOrdersParams({required this.request});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (request != null) data.addAll(request!.toJson());
    return data;
  }
}

class GetAllOrdersUsecase
    extends UseCase<List<OrderModel>, GetAllOrdersParams> {
  late final OrderRepository repository;
  GetAllOrdersUsecase(this.repository);

  @override
  Future<Result<List<OrderModel>>> call({required GetAllOrdersParams params}) {
    return repository.requestAllOrders(params: params);
  }
}
