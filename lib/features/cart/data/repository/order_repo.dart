import 'package:enjaz/features/cart/data/model/order_model.dart';

import '../../../../core/constant/end_points/api_url.dart';
import '../../../../core/data_source/remote_data_source.dart';
import '../../../../core/http/http_method.dart';
import '../../../../core/repository/core_repository.dart';
import '../../../../core/results/result.dart';
import '../usecase/create_order_usecase.dart';

class OrderRepository extends CoreRepository {
  Future<Result<OrderModel>> requestOrder({
    required CreateOrderParams params,
  }) async {
    final result = await RemoteDataSource.request<OrderModel>(
      withAuthentication: true,
      data: params.toJson(),
      url: createDrinkOrderUrl,
      method: HttpMethod.POST,
      converter: (json) {
        return OrderModel.fromJson(json);
      },
    );
    return call(result: result);
  }
}
