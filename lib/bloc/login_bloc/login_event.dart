part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class SendOtpEvent extends LoginEvent {
  final String phoneNumber;
  final Function(AuthCredential) onVerificationCompletedFunc;
  final Function(AuthException) onVerificationFailed;
  SendOtpEvent(
      {this.phoneNumber,
      this.onVerificationCompletedFunc,
      this.onVerificationFailed});
}

class VerifyOtpEvent extends LoginEvent {
  final String otp;
  VerifyOtpEvent({this.otp});
}

class ResendOtpEvent extends LoginEvent {
  final String phoneNumber;
  final Function(AuthCredential) onVerificationCompletedFunc;
  final Function(AuthException) onVerificationFailed;
  ResendOtpEvent(
      {this.phoneNumber,
      this.onVerificationCompletedFunc,
      this.onVerificationFailed});
}