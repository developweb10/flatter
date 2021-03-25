part of 'cards_bloc_bloc.dart';

abstract class CardsBlocState extends Equatable {
  const CardsBlocState();
  
  @override
  List<Object> get props => [];
}

class CardsBlocInitial extends CardsBlocState {}



class CardsBlocEmpty extends CardsBlocState {
  @override
  String toString() => 'CardsBlocEmpty';
}

class CardsLoading extends CardsBlocState {
  @override
  String toString() => 'CardsLoading';
}

class CardsLoaded extends CardsBlocState {
   List<CardsModel> cardsList;
  CardsLoaded(this.cardsList);

  @override
  String toString() => 'SearchStateSuccess { songs: ${cardsList.toString()} }';
}

class IndexSelected extends CardsBlocState {
  int index;
  IndexSelected(this.index);

  @override
  String toString() => 'SearchStateSuccess { songs: ${index.toString()} }';
}

class CardsError extends CardsBlocState {
  final String error;

  CardsError(this.error);

  @override
  String toString() => 'SearchStateError { error: $error }';
}