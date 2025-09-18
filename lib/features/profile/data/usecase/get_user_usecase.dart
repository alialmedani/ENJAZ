import 'package:enjaz/features/profile/data/model/user_model.dart';
import 'package:enjaz/features/profile/data/repo/user_repo.dart';
import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';

class GetCurrentUserParams extends BaseParams {
  GetCurrentUserParams();
}

class GetCurrentUserUsecase extends UseCase<UserModel, GetCurrentUserParams> {
  late final UserRepository repository;
  GetCurrentUserUsecase(this.repository);

  @override
  Future<Result<UserModel>> call({required GetCurrentUserParams params}) {
    return repository.requestCurrentUser(params: params);
  }
}
