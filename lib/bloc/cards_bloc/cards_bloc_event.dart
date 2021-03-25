part of 'cards_bloc_bloc.dart';

abstract class CardsBlocEvent extends Equatable {
  const CardsBlocEvent();

  @override
  List<Object> get props => [];
}

class LoadCards extends CardsBlocEvent {
 List<CardsModel> cardsList;

  LoadCards({this.cardsList});

  @override
  String toString() => "SearchTextChanged { query: ${cardsList.toString} }";
}

class AddCard extends CardsBlocEvent {
   List<CardsModel> cardsList;

  AddCard({this.cardsList});

  @override
  String toString() => "SearchTextChanged { query: ${cardsList.toString} }";
}

class SelectCard extends CardsBlocEvent {
   int index;

  SelectCard({this.index});

  @override
  String toString() => "SearchTextChanged { query: ${index.toString} }";
}