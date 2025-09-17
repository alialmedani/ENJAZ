// lib/features/profile/data/model/user_profile.dart
enum AppLanguage { ar, en }

class UserProfile {
  final String id;
  final String name;
  final String? avatarUrl;
  final AppLanguage language;
  final bool notificationsEnabled;
  final int defaultFloor; // 1..5
  final int defaultOffice; // 1..6
  final List<String> favorites; // أسماء مشروبات مفضّلة

  const UserProfile({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.language = AppLanguage.ar,
    this.notificationsEnabled = true,
    this.defaultFloor = 1,
    this.defaultOffice = 1,
    this.favorites = const [],
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    AppLanguage? language,
    bool? notificationsEnabled,
    int? defaultFloor,
    int? defaultOffice,
    List<String>? favorites,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      defaultFloor: defaultFloor ?? this.defaultFloor,
      defaultOffice: defaultOffice ?? this.defaultOffice,
      favorites: favorites ?? this.favorites,
    );
  }
}
