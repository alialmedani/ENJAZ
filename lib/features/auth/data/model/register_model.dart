class RegisterModel {
  final String? message;
  final String? userId; // نجعلها رقم الهاتف

  RegisterModel({this.message, this.userId});

  factory RegisterModel.success(String phone) =>
      RegisterModel(message: 'تم إنشاء الحساب بنجاح', userId: phone);
}
