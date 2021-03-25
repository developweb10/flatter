part of 'gift_sent_bloc_bloc.dart';

@immutable
abstract class GiftSentBlocEvent {}

class GiftSentListChanged extends GiftSentBlocEvent {


  @override
  String toString() => "SearchTextChanged {}";
}

class Refreshed extends GiftSentBlocEvent {
  final SentRequest sentRequest;

  Refreshed({this.sentRequest});

  @override
  String toString() => "SearchTextChanged { query: ${sentRequest.toString} }";
}