part of 'gift_recieved_bloc_bloc.dart';

@immutable
abstract class GiftRecievedBlocState{
   
}

class GiftRecievedBlocInitial extends GiftRecievedBlocState {}

class GiftReceivedEmpty extends GiftRecievedBlocState {
  @override
  String toString() => 'GiftReceivedEmpty';
}

class GiftReceivedLoading extends GiftRecievedBlocState {
  @override
  String toString() => 'GiftReceivedLoading';
}

class GiftReceivedSuccess extends GiftRecievedBlocState {
  final RecievedGifts recievedGifts;

  GiftReceivedSuccess(this.recievedGifts);


  @override
  String toString() => 'GiftReceivedSuccess { songs: ${recievedGifts.toString()} }';
}

class GiftReceivedError extends GiftRecievedBlocState {
  final String error;

  GiftReceivedError(this.error);

  @override
  String toString() => 'GiftReceivedError { error: $error }';
}