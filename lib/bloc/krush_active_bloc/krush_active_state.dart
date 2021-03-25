part of 'krush_active_bloc.dart';

@immutable
abstract class KrushActiveBlocState{
   
}

class KrushActiveBlocInitial extends KrushActiveBlocState {}

class SearchStateEmpty extends KrushActiveBlocState {
  @override
  String toString() => 'SearchStateEmpty';
}

class SearchStateLoading extends KrushActiveBlocState {
  @override
  String toString() => 'SearchStateLoading';
}

class SearchStateSuccess extends KrushActiveBlocState {
  final RecieveRequest recieveRequest;

  SearchStateSuccess(this.recieveRequest);


  @override
  String toString() => 'SearchStateSuccess { songs: ${recieveRequest.toString()} }';
}

class SearchStateError extends KrushActiveBlocState {
  final String error;

  SearchStateError(this.error);

  @override
  String toString() => 'SearchStateError { error: $error }';
}