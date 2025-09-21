import 'package:enjaz/features/auth/data/model/register_model.dart';
import 'package:enjaz/features/auth/data/repo/auth_repository.dart';

import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';

class RegisterParams extends BaseParams {
  String userName;
  String name;
  String phoneNumber;
  String officeId;
  String floorId;
  String password;
  List<String> roles;

  RegisterParams({
    required this.userName,
    required this.name,
    required this.phoneNumber,
    required this.roles,
    required this.officeId,
    required this.floorId,
    required this.password,
  });

  toJson() {
    return {
      "userName": userName,
      "name": name,
      "roles": roles,

      "phoneNumber": phoneNumber,
      "officeId": officeId,
      "floorId": floorId,
      "password": password,
    };
  }
}

class RegisterUseCase extends UseCase<RegisterModel, RegisterParams> {
  late final AuthRepository repository;
  RegisterUseCase(this.repository);

  @override
  Future<Result<RegisterModel>> call({required RegisterParams params}) {
    return repository.registerRequest(params: params);
  }
}
