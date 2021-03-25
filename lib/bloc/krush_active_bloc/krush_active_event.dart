part of 'krush_active_bloc.dart';
  


@immutable
abstract class KrushActiveBlocEvent extends Equatable{}

class ListChanged extends KrushActiveBlocEvent {

  ListChanged();

  @override
  String toString() => "SearchTextChanged {}";

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}


