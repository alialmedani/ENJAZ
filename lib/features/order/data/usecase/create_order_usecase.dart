import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../cart/data/model/create_item_model.dart';
import '../model/order_model.dart';
import '../repository/order_repo.dart';

class CreateOrderParams extends BaseParams {
  String floor;
  String office;
  List<CreateItemModel> orderItems;

  CreateOrderParams({
    required this.floor,
    required this.office,
    required this.orderItems,
  });

  toJson() {
    return {
      "Floor": floor,
      "Office": office,
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
