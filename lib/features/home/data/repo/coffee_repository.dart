// lib/features/home/data/repository/coffee_repository.dart
import 'package:enjaz/core/constant/end_points/api_url.dart';
import 'package:enjaz/core/http/http_method.dart';
import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/core/repository/core_repository.dart';
import 'package:enjaz/core/data_source/remote_data_source.dart';
import 'package:enjaz/features/home/data/model/coffee_api_model.dart';
import 'package:enjaz/features/home/data/usecase/coffee_api_params.dart';
import 'package:enjaz/features/home/data/usecase/coffee_list_params.dart';

class CoffeeRepository extends CoreRepository {
  static const bool _requiresAuth = false;

  Future<Result<List<CoffeeApiModel>>> listCoffees({
    required CoffeeListParams params,
  }) async {
    final result = await RemoteDataSource.request<List<CoffeeApiModel>>(
      withAuthentication: _requiresAuth,
      url: getlistdrink,
      method: HttpMethod.GET,
      queryParameters: params.toQuery(),
    converter2: (json) {
        // الـ API عندك بيرجع totalCount و items
        final list = (json is Map && json['items'] is List)
            ? json['items'] as List
            : (json as List? ?? const []);
        return list
            .map((e) => CoffeeApiModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },

    );
    return call(result: result);
  }

  Future<Result<CoffeeApiModel>> getCoffeeById({required String id}) async {
    final result = await RemoteDataSource.request<CoffeeApiModel>(
      withAuthentication: _requiresAuth,
      url: getbyId(id), // نفس الدالة اللي تبني URL
      method: HttpMethod.GET,
      converter: (json) {
        final map = (json is Map<String, dynamic>)
            ? json
            : (json['data'] as Map<String, dynamic>? ?? {});
        return CoffeeApiModel.fromJson(map);
      },
    );
    return call(result: result);
  }


  Future<Result<CoffeeApiModel>> createCoffee({
    required CreateCoffeeParams params,
  }) async {
    final result = await RemoteDataSource.request<CoffeeApiModel>(
      withAuthentication: _requiresAuth,
      url: createdrink,
      method: HttpMethod.POST,
      contentType: 'application/json',
      data: params.toJson(),
      converter: (json) {
        final map = (json is Map<String, dynamic>)
            ? json
            : (json['data'] as Map<String, dynamic>? ?? {});
        return CoffeeApiModel.fromJson(map);
      },
    );
    return call(result: result);
  }

  // Future<Result<CoffeeApiModel>> updateCoffee({
  //   required UpdateCoffeeParams params,
  // }) async {
  //   final result = await RemoteDataSource.request<CoffeeApiModel>(
  //     withAuthentication: _requiresAuth,
  //     url: getbyId(params.id),
  //     method: HttpMethod.PUT,
  //     contentType: 'application/json',
  //     data: params.toJson(),
  //     converter: (json) {
  //       final map = (json is Map<String, dynamic>)
  //           ? json
  //           : (json['data'] as Map<String, dynamic>? ?? {});
  //       return CoffeeApiModel.fromJson(map);
  //     },
  //   );
  //   return call(result: result);
  // }

  // Future<Result<String>> deleteCoffee({required int id}) async {
  //   final result = await RemoteDataSource.noModelRequest(
  //     withAuthentication: _requiresAuth,
  //     url: getbyId(id),
  //     method: HttpMethod.DELETE,
  //   );
  //   return call(result: result);
  // }
}
