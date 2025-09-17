// lib/features/profile/cubit/profile_cubit.dart
import 'package:enjaz/features/profile/data/repo/profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/features/profile/data/model/user_profile.dart';
 import 'package:enjaz/features/profile/data/usecase/update_settings_usecase.dart';

class ProfileCubit extends Cubit<UserProfile?> {
  ProfileCubit() : super(null);

  final ProfileRepository repo = ProfileRepository();

  void setProfile(UserProfile p) => emit(p);

  Future<Result<UserProfile>> updateSettings(UserProfile next) async {
    final usecase = UpdateSettingsUsecase(repo);
    final current = state!;
    final res = await usecase.call(current: current, next: next);
    if (res.hasDataOnly) emit(res.data!);
    return res;
  }

}
