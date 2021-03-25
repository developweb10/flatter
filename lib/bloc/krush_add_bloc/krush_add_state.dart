



part of 'krush_add_bloc.dart';


@immutable
abstract class KrushAddState {}



class KrushAddBlocInitial extends KrushAddState {}

class KrushAddStateEmpty extends KrushAddState {
  @override
  String toString() => 'KrushAddStateEmpty';
}

class KrushAddStateLoading extends KrushAddState {
  @override
  String toString() => 'KrushAddStateLoading';
}

class KrushAddStateFreeRequestsNotEnough extends KrushAddState {
  @override
  String toString() => 'KrushAddStateNoFreeRequests';
}

class KrushAddStateOkToSend extends KrushAddState {
  
  @override
  String toString() => 'KrushAddStateOkToSend';
}

class SubscribedOkToAdd extends KrushAddState {
  
  @override
  String toString() => 'SubscribedOkToAdd';
}


class KrushAddStateSuccess extends KrushAddState {

  @override
  String toString() => 'SearchStateSuccess}';
}

class Subscription extends KrushAddState{

    @override
  String toString() => 'SearchStateSuccess}';
}

class KrushAddStateError extends KrushAddState {
  final String error;

  KrushAddStateError(this.error);

  @override
  String toString() => 'SearchStateError { error: $error }';
}