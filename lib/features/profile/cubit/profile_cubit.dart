// lib/features/profile/profile_glue.dart


// ===============================
// 2) ProfileCubit: يستخدم UseCase وبنفس Result عندك + يـ emit الحالة
// ===============================

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/features/profile/data/model/user_model.dart';
import 'package:enjaz/features/profile/data/usecase/get_user_usecase.dart';
import 'package:enjaz/features/profile/data/repo/user_repo.dart';

 class ProfileCubit extends Cubit<UserModel?> {
  ProfileCubit() : super(null);

   Future<Result<UserModel>> fetchCurrentCustomer() async {
    final usecase = GetCurrentUserUsecase(UserRepository());
    final result = await usecase.call(params: GetCurrentUserParams());

    if (result.hasDataOnly && result.data != null) {
      emit(result.data);
    }
     return result;
  }
}

 
