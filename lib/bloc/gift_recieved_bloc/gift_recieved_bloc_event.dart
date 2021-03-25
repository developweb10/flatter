part of 'gift_recieved_bloc_bloc.dart';
  


@immutable
abstract class GiftReceivedBlocEvent extends Equatable{}

class GiftsListChanged extends GiftReceivedBlocEvent {


  @override
  String toString() => "SearchTextChanged {}";

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}



