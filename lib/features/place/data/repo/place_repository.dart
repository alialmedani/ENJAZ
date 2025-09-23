import 'package:enjaz/core/constant/end_points/api_url.dart';
import 'package:enjaz/core/data_source/remote_data_source.dart';
import 'package:enjaz/core/http/http_method.dart';
import 'package:enjaz/core/repository/core_repository.dart';
import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/features/place/data/model/place_model.dart';
import 'package:enjaz/features/place/data/usecase/get_place_usecase.dart';

class PlaceRepository extends CoreRepository {
  Future<Result<List<PlaceModel>>> getPlace({
    required GetPlaceParam params,
  }) async {
    final result = await RemoteDataSource.request<List<PlaceModel>>(
      withAuthentication: false,
      queryParameters: params.toJson(),
      url: getPlaceUrl,
      method: HttpMethod.GET,
      converter2: (json) {
        return List<PlaceModel>.from(json.map((x) => PlaceModel.fromJson(x)));
      },
    );
    return call(result: result);
  }
}
