// lib/features/order/data/usecase/get_orders_usecase.dart
import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/features/order/data/model/order_model.dart';
import 'package:enjaz/features/order/data/repository/order_repository.dart';

class GetOrdersUseCase {
  final OrderRepository _repo;
  GetOrdersUseCase(this._repo);

  Future<Result<List<OrderModel>>> call() {
    return _repo.getOrders();
  }
}
