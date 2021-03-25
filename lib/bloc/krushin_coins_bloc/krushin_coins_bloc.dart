import 'dart:async';

import 'package:bloc/bloc.dart';
import '../../app/shared_prefrence.dart';
import '../../repositories/krushin_coins_repository.dart';
import 'package:meta/meta.dart';

part 'krushin_coins_event.dart';
part 'krushin_coins_state.dart';

class KrushinCoinsBloc extends Bloc<KrushinCoinsEvent, KrushinCoinsState> {
  KrushinCoinsBloc() : super(CoinsAdding());

  final KrushinCoinsRepository krushinCoinsRepository =
      KrushinCoinsRepository();

  @override
  Stream<KrushinCoinsState> mapEventToState(
    KrushinCoinsEvent event,
  ) async* {
    if (event is AddCoins) {
      yield CoinsAdding();
      try {
        int result = await krushinCoinsRepository.addCoins( event.coins);
        if (result != null) {
          yield CoinsAdded(result);
        } else {
          yield CoinsAddingFailed();
        }
      } catch (error) {
        yield CoinsAddingFailed();
      }
    } else if (event is GetCoins) {
      yield CoinsAdding();
      try {
        int result = await krushinCoinsRepository.getCoins();
        if (result != null) {
          yield CoinsAdded(result);
        } else {
          yield CoinsAddingFailed();
        }
      } catch (error) {
        yield CoinsAddingFailed();
      }
    }
  }

  @override
  // TODO: implement initialState
  KrushinCoinsState get initialState => CoinsAdding();
}
