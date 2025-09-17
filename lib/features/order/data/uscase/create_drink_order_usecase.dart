// import 'package:enjaz/features/order/data/model/order_model.dart';
// import 'package:enjaz/features/order/data/repository/order_repository.dart';

// import '../../../../core/params/base_params.dart';
// import '../../../../core/results/result.dart';
// import '../../../../core/usecase/usecase.dart';
// import 'create_order_item_usecase.dart';

// class CreateDrinkOrderParams extends BaseParams {
//   int floor; // 👈 int
//   String office;
//   List<CreateOrderItemParams> orderItems;

//   CreateDrinkOrderParams({
//     required this.floor,
//     required this.office,
//     required this.orderItems,
//   });

//   toJson() => {
//     "floor": floor,
//     "office": office,
//     "orderItems": orderItems.map((e) => e.toJson()).toList(),
//   };
// }


// class CreateDrinkOrderUseCase
//     extends UseCase<OrderModel, CreateDrinkOrderParams> {
//   late final OrderRepository repository;
//   CreateDrinkOrderUseCase(this.repository);

//   @override
//   Future<Result<OrderModel>> call({
//     required CreateDrinkOrderParams params,
//   }) {
//     return repository.createDrinkOrder(params: params);
//   }
// }
// //create order 