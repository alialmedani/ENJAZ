import 'package:enjaz/core/constant/end_points/api_url.dart';
import 'package:enjaz/core/http/http_method.dart';
import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/core/repository/core_repository.dart';
import 'package:enjaz/core/data_source/remote_data_source.dart';
 import 'package:enjaz/features/officeboy/data/model/officeboy_model.dart';
import 'package:enjaz/features/officeboy/data/model/status_order_model.dart';
import 'package:enjaz/features/officeboy/data/usecase/get_order_usecase.dart';
import 'package:enjaz/features/officeboy/data/usecase/status_order_usecase.dart';
 class OfficeBoyRepository extends CoreRepository {
  Future<Result<List<OfficeBoyModel>>> requestGetOrderOfficeBoy({
    required GetOrderOfficeBoyParams params,
  }) async {
    final result = await RemoteDataSource.request<List<OfficeBoyModel>>(
      withAuthentication: true,
      url: getOrdersUrl,
      method: HttpMethod.GET,
      queryParameters: params.toJson(),
      converter: (json) {
        final model = OfficeBoyModel.fromJson(json);
        return [model]; // جسم واحد ملفوف داخل List
      },
    );
    return call(result: result);
  }

    Future<Result<SatusOrderModel>> updateOrderStatus({
    required UpdateOrderStatusParams params,
  }) async {
    final result = await RemoteDataSource.request<SatusOrderModel>(
      withAuthentication: true,
      data: params.toJson(),
      url: createDrinkOrderUrl,
      method: HttpMethod.POST,
      converter: (json) {
        return SatusOrderModel.fromJson(json);
      },
    );
    return call(result: result);
  }

}

