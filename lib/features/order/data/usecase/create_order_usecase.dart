import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../cart/data/model/create_item_model.dart';
import '../model/order_model.dart';
import '../repository/order_repo.dart';

class CreateOrderParams extends BaseParams {
  String floorId;
  String officeId;
  List<CreateItemModel> orderItems;

  CreateOrderParams({
    required this.floorId,
    required this.officeId,
    required this.orderItems,
  });

  toJson() {
    return {
      "floorId": floorId,
      "officeId": officeId,
      "OrderItems": orderItems.map((item) => item.toJson()).toList(),
    };
  }
}

class CreateOrderUsecase extends UseCase<OrderModel, CreateOrderParams> {
  late final OrderRepository repository;
  CreateOrderUsecase(this.repository);

  @override
  Future<Result<OrderModel>> call({required CreateOrderParams params}) {
    return repository.requestOrder(params: params);
  }
}
