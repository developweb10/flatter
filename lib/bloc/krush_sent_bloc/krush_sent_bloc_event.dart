part of 'krush_sent_bloc_bloc.dart';

@immutable
abstract class KrushSentBlocEvent {}

class KrushSentListChanged extends KrushSentBlocEvent {
  final SentRequest sentRequest;

  KrushSentListChanged({this.sentRequest});

  @override
  String toString() => "SearchTextChanged { query: ${sentRequest.toString} }";
}
