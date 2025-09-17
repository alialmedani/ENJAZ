import 'package:enjaz/core/constant/end_points/api_url.dart';
import 'package:enjaz/core/http/http_method.dart';
import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/core/repository/core_repository.dart';
import 'package:enjaz/core/data_source/remote_data_source.dart';
import 'package:enjaz/features/drink/data/model/drink_model.dart';
import '../usecase/get_all_drink_usecase.dart';

class DrinkRepository extends CoreRepository {

  Future<Result<List<DrinkModel>>> requestAllDrink({
    required GetAllDrinkParams params,
  }) async {
    final result = await RemoteDataSource.request<List<DrinkModel>>(
      withAuthentication: false,
      url: getlistdrink,
      method: HttpMethod.GET,
      queryParameters: params.toJson(),
      converter: (json) {
        return json["items"] == null
            ? []
            : List<DrinkModel>.from(
                json["items"]!.map((x) => DrinkModel.fromJson(x)),
              );
      },
    );
    return call(result: result);
  }

}
