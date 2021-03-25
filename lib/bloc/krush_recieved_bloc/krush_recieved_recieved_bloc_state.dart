part of 'krush_recieved_bloc_bloc.dart';

@immutable
abstract class KrushRequestBlocState{
   
}

class KrushRequestBlocInitial extends KrushRequestBlocState {}

class KrushRequestEmpty extends KrushRequestBlocState {
  @override
  String toString() => 'KrushRequestEmpty';
}

class KrushRequestLoading extends KrushRequestBlocState {
  @override
  String toString() => 'KrushRequestLoading';
}

class KrushRequestSuccess extends KrushRequestBlocState {
  final RecieveRequest recieveRequest;

  KrushRequestSuccess(this.recieveRequest);


  @override
  String toString() => 'KrushRequestSuccess { songs: ${recieveRequest.toString()} }';
}

class KrushRequestError extends KrushRequestBlocState {
  final String error;

  KrushRequestError(this.error);

  @override
  String toString() => 'KrushRequestError { error: $error }';
}