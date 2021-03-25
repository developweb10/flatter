part of 'krush_sent_bloc_bloc.dart';

@immutable
abstract class KrushSentBlocState{
   
}

class KrushSentBlocInitial extends KrushSentBlocState {}

class SearchStateEmpty extends KrushSentBlocState {
  @override
  String toString() => 'SearchStateEmpty';
}

class SearchStateLoading extends KrushSentBlocState {
  @override
  String toString() => 'SearchStateLoading';
}

class SearchStateSuccess extends KrushSentBlocState {
  final SentRequest requestSent;

  SearchStateSuccess(this.requestSent);


  @override
  String toString() => 'SearchStateSuccess { songs: ${requestSent.toString()} }';
}

class SearchStateError extends KrushSentBlocState {
  final String error;

  SearchStateError(this.error);

  @override
  String toString() => 'SearchStateError { error: $error }';
}