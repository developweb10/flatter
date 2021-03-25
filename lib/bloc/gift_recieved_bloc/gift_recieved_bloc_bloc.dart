import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:krushapp/model/recieved_gifts.dart';
import 'package:krushapp/repositories/gift_repository.dart';
import '../../app/api.dart';
import '../../app/shared_prefrence.dart';
import 'package:meta/meta.dart';
part 'gift_recieved_bloc_event.dart';
part 'gift_recieved_recieved_bloc_state.dart';

class GiftRecievedBloc
    extends Bloc<GiftReceivedBlocEvent, GiftRecievedBlocState> {
  ApiClient _client;

  GiftRecievedBloc() : super(GiftReceivedLoading());

  GiftRepository giftRepository= GiftRepository();
  @override
  void onTransition(
      Transition<GiftReceivedBlocEvent, GiftRecievedBlocState> transition) {
    
    super.onTransition(transition);
  }

  @override
  Stream<GiftRecievedBlocState> mapEventToState(
    GiftReceivedBlocEvent event,
  ) async* {
    if (event is GiftsListChanged) {
      //  yield GiftReceivedLoading();
      try {
        final result = await giftRepository.getRecievedGifts();
        yield GiftReceivedSuccess(result);
      } catch (error) {
        yield GiftReceivedError(error);
      }
    }

  }
}
