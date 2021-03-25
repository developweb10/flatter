



part of 'request_action_bloc.dart';


@immutable
abstract class RequestActionState {}



class RequestActionBlocInitial extends RequestActionState {}

class RequestActionStateEmpty extends RequestActionState {
  @override
  String toString() => 'RequestActionStateEmpty';
}

class RequestActionStateLoading extends RequestActionState {
  @override
  String toString() => 'RequestActionStateLoading';
}

class RequestActionStateFreeRequestsNotEnough extends RequestActionState {
  @override
  String toString() => 'RequestActionStateNoFreeRequests';
}

class RequestActionStateOkToSend extends RequestActionState {
  
  @override
  String toString() => 'RequestActionStateOkToSend';
}

class SubscribedOkToAccept extends RequestActionState {
  
  @override
  String toString() => 'SubscribedOkToAccept';
}

class RequestActionStateSuccess extends RequestActionState {

  @override
  String toString() => 'SearchStateSuccess}';
}

class Subscription extends RequestActionState{

    @override
  String toString() => 'SearchStateSuccess}';
}

class RequestActionStateError extends RequestActionState {
  final String error;

  RequestActionStateError(this.error);

  @override
  String toString() => 'SearchStateError { error: $error }';
}