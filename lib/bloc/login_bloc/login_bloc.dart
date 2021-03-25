import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:krushapp/services/login_service.dart';
import 'package:krushapp/utils/service_locator.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());

  LoginService _loginService = locator<LoginService>();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is SendOtpEvent) {
      yield* sendOtp(event);
    } else if (event is VerifyOtpEvent) {
      yield* verifyOtp(event);
    } else if (event is ResendOtpEvent) {
      _loginService.resendOtp(event.phoneNumber,
          event.onVerificationCompletedFunc, event.onVerificationFailed);
    }
  }

  Stream<LoginState> sendOtp(SendOtpEvent event) async* {
    try {
      await _loginService.sendOtp(event.phoneNumber,
          event.onVerificationCompletedFunc, event.onVerificationFailed);
      yield OtpSentState();
    } catch (e) {
      yield PhoneLoginErrorState(errorMessage: 'Error Sending Otp! Try Again');
    }
  }

  Stream<LoginState> verifyOtp(VerifyOtpEvent event) async* {
    try {
      // final user = await _loginService.signInWithSmsCode(event.otp);
      // _userRepository.setUserId(user.uid);
      // if (await _userRepository.isNewUser()) {
      //   yield NewUserState(user: UserModel.fromFirebaseUser(user));
      // } else {
      //   final userData = await _userRepository.getUserFromFirebase();
      //   if (locator.isRegistered<UserModel>()) locator.unregister<UserModel>();
      //   locator.registerSingleton<UserModel>(userData);
      //   yield LoggedInState();
      // }
    } catch (e) {
      yield PhoneLoginErrorState(
          errorMessage: 'Error Verifying Otp! Try Again');
    }
  }
}
