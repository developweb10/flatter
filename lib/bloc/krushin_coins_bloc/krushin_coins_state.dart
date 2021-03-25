part of 'krushin_coins_bloc.dart';

@immutable
abstract class KrushinCoinsState {}


class CoinsAdding extends KrushinCoinsState {
  @override
  String toString() => 'CoinsAdding';
}

class CoinsAdded extends KrushinCoinsState {

  final int coins_count;

  CoinsAdded(this.coins_count);
  @override
  String toString() => 'CoinsAdded';
}

class CoinsAddingFailed extends KrushinCoinsState {



  @override
  String toString() => 'CoinsAddingFailed';
}
