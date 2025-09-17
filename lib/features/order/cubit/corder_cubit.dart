import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/features/order/data/model/order_model.dart';
import 'package:enjaz/features/order/data/repository/order_repository.dart';
import 'package:enjaz/features/order/data/uscase/get_orders_usecase.dart';
import 'package:enjaz/features/order/data/uscase/create_drink_order_lite_usecase.dart';

class OrderCubit extends Cubit<void> {
  OrderCubit() : super(null);

  final OrderRepository _repo = OrderRepository();
  late final GetOrdersUseCase _getOrdersUC = GetOrdersUseCase(_repo);
  late final CreateDrinkOrderLiteUseCase _addItemUC =
      CreateDrinkOrderLiteUseCase(_repo);

  Future<Result<OrderModel>> addItemToOrder({
    required String drinkId,
    int quantity = 1,
    int? sugarLevel,
    String? notes,
  }) async {
    final params = CreateDrinkOrderLiteParams(
      drinkId: drinkId,
      quantity: quantity,
      sugarLevel: sugarLevel,
      notes: notes,
    );
    return await _addItemUC(params: params);
  }

  Future<Result<List<OrderModel>>> getOrders() => _getOrdersUC();
}
