part of 'auth_cubit.dart';

 sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoginButtonStateChanged extends AuthState {
  final bool isEnabled;
  AuthLoginButtonStateChanged(this.isEnabled);
}

class AuthVerificationButtonStateChanged extends AuthState {
  final bool isEnabled;
  AuthVerificationButtonStateChanged(this.isEnabled);
}

final class AuthTimerTick extends AuthState {
  final int secondsLeft;
  final bool canResend;

  AuthTimerTick(this.secondsLeft, this.canResend);
}
