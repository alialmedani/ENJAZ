import 'package:enjaz/core/constant/end_points/api_url.dart';
import 'package:enjaz/core/http/http_method.dart';
import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/core/repository/core_repository.dart';
import 'package:enjaz/core/data_source/remote_data_source.dart';
import 'package:enjaz/features/profile/data/model/user_model.dart';

import '../usecase/get_user_usecase.dart';

class UserRepository extends CoreRepository {
  Future<Result<UserModel>> requestCurrentUser({
    required GetCurrentUserParams params,
  }) async {
    final result = await RemoteDataSource.request<UserModel>(
      withAuthentication: true,
      url: currentUserUrl,
      method: HttpMethod.GET,
      converter: (json) {
        return UserModel.fromJson(json);
      },
    );
    return call(result: result);
  }
}
