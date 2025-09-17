import 'package:enjaz/core/params/base_params.dart';
import 'package:enjaz/core/usecase/usecase.dart';
import 'package:enjaz/features/auth/data/model/login_model.dart';
import 'package:enjaz/features/auth/data/repo/auth_repository.dart';
 
import '../../../../core/results/result.dart';

class RefreshTokenParams extends BaseParams {
  String refreshToken;
  String grantType;
  String clientId;

  RefreshTokenParams({
    required this.grantType,
    required this.clientId,
    required this.refreshToken,
  });
  toJson() {
    return {
      "grant_type": grantType,
      "client_id": clientId,
      "refresh_token": refreshToken,
    };
  }
}

class RefreshTokenUsecase extends UseCase<LoginModel, RefreshTokenParams> {
  late final AuthRepository repository;
  RefreshTokenUsecase(this.repository);

  @override
  Future<Result<LoginModel>> call({required RefreshTokenParams params}) {
    return repository.refreshTokenRequest(params: params);
  }
}
