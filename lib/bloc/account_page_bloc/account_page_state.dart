part of 'account_page_bloc.dart';

@immutable
abstract class AccountPageState {}

class AccountPageInitial extends AccountPageState {

}

class ProfileImageLoading extends AccountPageState {
  @override
  String toString() => 'ProfileImageLoading';
}

class ProfileInfoLoading extends AccountPageState {
  @override
  String toString() => 'ProfileInfoLoading';
}

class AllInfoLoading extends AccountPageState {
  @override
  String toString() => 'AllInfoLoading';
}

class ProfileImageUpdated extends AccountPageState {

    String imageUrl;

  ProfileImageUpdated(this.imageUrl);

  @override
  String toString() => 'ProfileImageUpdated';
}

class ProfileInfoUpdated extends AccountPageState {
  UserResponse userResponse;

  ProfileInfoUpdated(this.userResponse);
  @override
  String toString() => 'ProfileInfoUpdated';
}

class AllInfoLoaded extends AccountPageState {

    UserResponse userResponse;

  AllInfoLoaded(this.userResponse);

  @override
  String toString() => 'AllInfoLoaded';
}



class ProfileImageError extends AccountPageState {
  final String error;

  ProfileImageError(this.error);

  @override
  String toString() => 'ProfileImageError { error: $error }';
}

class ProfileInfoError extends AccountPageState {
  final String error;

  ProfileInfoError(this.error);

  @override
  String toString() => 'SearchStateError { error: $error }';
}