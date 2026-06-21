/// Mirrors backend `UserBasicDto` returned by the user autocomplete endpoint:
/// { id, userName, fullName, email }
class DeskUserModel {
  String? id;
  String? userName;
  String? fullName;
  String? email;

  DeskUserModel({this.id, this.userName, this.fullName, this.email});

  DeskUserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    fullName = json['fullName'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'fullName': fullName,
      'email': email,
    };
  }

  /// Best human-readable name for display.
  String get displayName {
    if (fullName != null && fullName!.trim().isNotEmpty) return fullName!;
    if (userName != null && userName!.trim().isNotEmpty) return userName!;
    return email ?? '';
  }
}
