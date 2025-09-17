// lib/features/profile/data/repository/profile_repository.dart
import 'package:enjaz/core/results/result.dart';
import 'package:enjaz/features/profile/data/datasource/profile_static_data_source.dart';
import 'package:enjaz/features/profile/data/model/order_history_entry.dart';
import 'package:enjaz/features/profile/data/model/user_profile.dart';

class ProfileRepository {
  final IProfileStaticDataSource ds;
  ProfileRepository({IProfileStaticDataSource? dataSource})
    : ds = dataSource ?? ProfileStaticDataSource();

  Future<Result<UserProfile>> getProfile() async {
    try {
      final p = await ds.getProfile();
      return Result<UserProfile>(data: p);
    } catch (e) {
      return Result<UserProfile>(error: e.toString());
    }
  }

  Future<Result<UserProfile>> updateSettings({
    AppLanguage? language,
    bool? notificationsEnabled,
    int? defaultFloor,
    int? defaultOffice,
  }) async {
    try {
      final p = await ds.updateSettings(
        language: language,
        notificationsEnabled: notificationsEnabled,
        defaultFloor: defaultFloor,
        defaultOffice: defaultOffice,
      );
      return Result<UserProfile>(data: p);
    } catch (e) {
      return Result<UserProfile>(error: e.toString());
    }
  }

  Future<Result<List<OrderHistoryEntry>>> getHistory() async {
    try {
      final h = await ds.getOrderHistory();
      return Result<List<OrderHistoryEntry>>(data: h);
    } catch (e) {
      return Result<List<OrderHistoryEntry>>(error: e.toString());
    }
  }
}
