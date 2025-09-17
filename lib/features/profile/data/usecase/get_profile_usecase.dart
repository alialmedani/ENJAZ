// lib/features/profile/data/usecase/get_profile_usecase.dart
import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/features/profile/data/model/user_profile.dart';
import 'package:enjaz/features/profile/data/repo/profile_repository.dart';
 
class GetProfileUsecase {
  final ProfileRepository repo;
  GetProfileUsecase(this.repo);

  Future<Result<UserProfile>> call() => repo.getProfile();
}
