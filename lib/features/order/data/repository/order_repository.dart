import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/core/repository/core_repository.dart';
import 'package:enjaz/core/http/http_method.dart';
import 'package:enjaz/core/data_source/remote_data_source.dart';
import 'package:enjaz/core/constant/end_points/api_url.dart';
import 'package:enjaz/features/order/data/model/order_model.dart';
import '../uscase/create_drink_order_lite_usecase.dart';

class OrderRepository extends CoreRepository {
  // إضافة عنصر واحد (lite)
  Future<Result<OrderModel>> createDrinkOrderLite({
    required CreateDrinkOrderLiteParams params,
  }) async {
    final result = await RemoteDataSource.request<OrderModel>(
      withAuthentication: true,
      url: createDrinkOrderLiteUrl, // تأكد من تعريفه بـ api_url.dart
      method: HttpMethod.POST,
      data: params.toJson(),
      converter: (json) => OrderModel.fromJson(json),
    );
    return call(result: result);
  }

  // جلب الطلبات (تستخدمها OrdersScreen)
  Future<Result<List<OrderModel>>> getOrders() async {
    final result = await RemoteDataSource.request<List<OrderModel>>(
      withAuthentication: true,
      url: getOrdersUrl,
      method: HttpMethod.GET,
      converter2: (json) {
        final list = (json is List)
            ? json
            : (json['items'] as List?) ?? (json['data'] as List?) ?? const [];
        return list
            .whereType<Map>()
            .map((e) => OrderModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      },
    );
    return call(result: result);
  }
}
