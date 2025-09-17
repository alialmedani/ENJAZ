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
// في AuthCubit
  void updateCredentials(String username, String password) {
    final u = username.trim();
    final p = password.trim();

    // قواعد تمكين بسيطة:
    final userOk = u.isNotEmpty; // أو اخضعه لقواعدك: طول معيّن/regex
    final passOk = p.length >= 6; // عدّلها حسب سياستك

    final shouldEnable = userOk && passOk;

    if (isLoginButtonEnabled != shouldEnable) {
      isLoginButtonEnabled = shouldEnable;
      emit(AuthLoginButtonStateChanged(shouldEnable));
    }

    // خزّن القيم لتستخدمها عند الضغط
    loginParams.username = u;
    loginParams.password = p;
  }

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
