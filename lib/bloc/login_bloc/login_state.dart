part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoggedInState extends LoginState {}

class NewUserState extends LoginState {
  // final UserModel user;
  // NewUserState({this.user});
}

class OtpSentState extends LoginState {}

class PhoneLoginLoadingState extends LoginState {}

class PhoneLoginErrorState extends LoginState {
  final String errorMessage;
  PhoneLoginErrorState({this.errorMessage});
}