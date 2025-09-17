import 'package:bloc/bloc.dart';
import 'package:enjaz/features/auth/data/repo/auth_repository.dart';
import 'package:enjaz/features/auth/data/uscase/login_usecase.dart';
 import 'dart:async';
import '../../../core/results/result.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  bool isLoginButtonEnabled = false;
  bool isVerificationButtonEnabled = false;
  bool canResend = false;
  int remainingSeconds = 60;
  Timer? _timer;

  LoginParams loginParams = LoginParams(
     username: '1',
    password: '1',
    grantType: 'password',
    clientId: 'CoffeeApp_App',
    scope: 'offline_access openid profile email',
  );


  Future<Result> login() async {
    return await LoginUsecase(AuthRepository()).call(params: loginParams);
  }

  void toggleLoginButton(String value) {
    String cleaned = value.trim();

    if (cleaned.startsWith('0')) {
      cleaned = cleaned.substring(1);
    }
  }

  void stopTimer() {
    _timer?.cancel();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
