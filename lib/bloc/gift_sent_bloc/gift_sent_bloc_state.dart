part of 'gift_sent_bloc_bloc.dart';

@immutable
abstract class GiftSentBlocState{
   
}

class GiftSentBlocInitial extends GiftSentBlocState {}

class SearchStateEmpty extends GiftSentBlocState {
  @override
  String toString() => 'SearchStateEmpty';
}

class SearchStateLoading extends GiftSentBlocState {
  @override
  String toString() => 'SearchStateLoading';
}

class SearchStateSuccess extends GiftSentBlocState {
  final SentGifts sentGifts;

  SearchStateSuccess(this.sentGifts);


  @override
  String toString() => 'SearchStateSuccess { songs: ${sentGifts.toString()} }';
}

class SearchStateError extends GiftSentBlocState {
  final String error;

  SearchStateError(this.error);

  @override
  String toString() => 'SearchStateError { error: $error }';
}