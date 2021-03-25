part of 'krushin_coins_bloc.dart';

@immutable
abstract class KrushinCoinsEvent {}

class AddCoins extends KrushinCoinsEvent {
  final int coins;
  AddCoins({
    this.coins
  });
}

class GetCoins extends KrushinCoinsEvent {
  final int coins;
  GetCoins({
    this.coins
  });
}