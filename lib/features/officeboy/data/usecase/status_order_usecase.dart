import 'package:enjaz/core/params/base_params.dart';
import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/core/usecase/usecase.dart';
import 'package:enjaz/features/officeboy/data/model/status_order_model.dart';
import 'package:enjaz/features/officeboy/data/repo/office_boy_repo.dart';
 class UpdateOrderStatusParams extends BaseParams {
   String orderId;
   int status;

  UpdateOrderStatusParams({required this.orderId, required this.status});

  Map<String, dynamic> toJson() => {
    "orderId": orderId,
    "status": status, 
  };
}
class UpdateOrderStatusUsecase
    extends UseCase<SatusOrderModel, UpdateOrderStatusParams> {
  final OfficeBoyRepository repository;
  UpdateOrderStatusUsecase(this.repository);

  @override
  Future<Result<SatusOrderModel>> call({
    required UpdateOrderStatusParams params,
  }) {
    return repository.updateOrderStatus(params: params);
  }
}
