// lib/features/profile/data/usecase/update_settings_usecase.dart
import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/features/profile/data/model/user_profile.dart';
import 'package:enjaz/features/profile/data/repo/profile_repository.dart';
 
class UpdateSettingsUsecase {
  final ProfileRepository repo;
  UpdateSettingsUsecase(this.repo);

  Future<Result<UserProfile>> call({
    required UserProfile current,
    required UserProfile next,
  }) {
    return repo.updateSettings(
      language: next.language,
      notificationsEnabled: next.notificationsEnabled,
      defaultFloor: next.defaultFloor,
      defaultOffice: next.defaultOffice,
    );
  }
}
