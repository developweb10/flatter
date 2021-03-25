import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:krushapp/repositories/gift_repository.dart';
import '../../model/sent_gifts.dart';
import '../../app/api.dart';
import '../../app/shared_prefrence.dart';
import '../../model/sent_request.dart';
import 'package:meta/meta.dart';

part 'gift_sent_bloc_event.dart';
part 'gift_sent_bloc_state.dart';

class GiftSentBloc extends Bloc<GiftSentBlocEvent, GiftSentBlocState> {
  ApiClient _client;
  final GiftRepository giftRepository = GiftRepository();
  GiftSentBloc() : super(SearchStateLoading());

  @override
  void onTransition(
      Transition<GiftSentBlocEvent, GiftSentBlocState> transition) {
  
    super.onTransition(transition);
  }

  @override
  Stream<GiftSentBlocState> mapEventToState(
    GiftSentBlocEvent event,
  ) async* {
    if (event is GiftSentListChanged) {
      // yield SearchStateLoading();
      try {
        final result = await giftRepository
            .getSentGifts();
        
        yield SearchStateSuccess(result);
      } catch (error) {
        yield SearchStateError(error);
      }
    }
  }

//   Stream<giftSentBlocState> _mapListChangedToState(ListChanged event) async* {

// }

}
