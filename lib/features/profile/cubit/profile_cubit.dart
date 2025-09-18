import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/features/profile/data/model/user_profile.dart';
import '../data/model/user_model.dart';
import '../data/repo/user_repo.dart';
import '../data/usecase/get_user_usecase.dart';

class ProfileCubit extends Cubit<UserProfile?> {
  ProfileCubit() : super(null);


  Future<Result> fetchCurrentCustomer() async {
    Result<UserModel> result = await GetCurrentUserUsecase(
      UserRepository(),
    ).call(params: GetCurrentUserParams());

    return result;
  }
}
