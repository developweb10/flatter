part of 'request_action_bloc.dart';



@immutable
abstract class RequestActionEvent {}

class CheckAcceptKrush extends RequestActionEvent {

  CheckAcceptKrush();

  @override
  String toString() => "SearchTextChanged { query:}";
}


class RequestAction extends RequestActionEvent {
  final int relationId;
  final String uri;


  RequestAction(this.relationId, this.uri);

  @override
  String toString() => "SearchTextChanged { query:}";
}

class Subsciption extends RequestActionEvent {

  @override
  String toString() => "SearchTextChanged { query:}";
}