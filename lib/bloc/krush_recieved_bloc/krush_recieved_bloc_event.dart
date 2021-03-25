part of 'krush_recieved_bloc_bloc.dart';
  


@immutable
abstract class KrushRequestBlocEvent extends Equatable{}

class KrushRequestListChanged extends KrushRequestBlocEvent {


  @override
  String toString() => "SearchTextChanged {}";

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class KrushRequestRefreshed extends KrushRequestBlocEvent {


  @override
  String toString() => "SearchTextChanged {}";

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

