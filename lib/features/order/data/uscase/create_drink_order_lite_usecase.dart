import 'package:enjaz/core/params/base_params.dart';
import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/core/usecase/usecase.dart';
import 'package:enjaz/features/order/data/model/order_model.dart';
import 'package:enjaz/features/order/data/repository/order_repository.dart';

class CreateDrinkOrderLiteParams extends BaseParams {
  final String drinkId;
  final int quantity;
  final int? sugarLevel; // اختياري
  final String? notes; // اختياري

  CreateDrinkOrderLiteParams({
    required this.drinkId,
    required this.quantity,
    this.sugarLevel,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    "drinkId": drinkId,
    "quantity": quantity,
    if (sugarLevel != null) "sugarLevel": sugarLevel,
    if (notes != null && notes!.isNotEmpty) "notes": notes,
  };
}

class CreateDrinkOrderLiteUseCase
    extends UseCase<OrderModel, CreateDrinkOrderLiteParams> {
  final OrderRepository repository;
  CreateDrinkOrderLiteUseCase(this.repository);

  @override
  Future<Result<OrderModel>> call({
    required CreateDrinkOrderLiteParams params,
  }) {
    return repository.createDrinkOrderLite(params: params);
  }
}
