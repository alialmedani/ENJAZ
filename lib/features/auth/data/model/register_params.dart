class RegisterParams {
  String username;
  String phone;
  String password;
  int floor; // 1..5
  int office; // 1..6

  RegisterParams({
    this.username = '',
    this.phone = '',
    this.password = '',
    this.floor = 1,
    this.office = 1,
  });
}
