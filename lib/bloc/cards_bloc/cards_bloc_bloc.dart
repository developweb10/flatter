import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:krushapp/model/card_model.dart';
import 'package:krushapp/repositories/payment_page_repository.dart';

part 'cards_bloc_event.dart';
part 'cards_bloc_state.dart';

class CardsBlocBloc extends Bloc<CardsBlocEvent, CardsBlocState> {
  CardsBlocBloc() : super(CardsLoading());
PaymentPageRepository  paymentPageRepository = PaymentPageRepository();
  @override
  Stream<CardsBlocState> mapEventToState(
    CardsBlocEvent event,
  ) async* {
       if (event is LoadCards) {
       yield CardsLoading();
      try {
        final result = await paymentPageRepository
            .getCards();
        yield CardsLoaded(result);
      } catch (error) {
        print(error.toString());
        yield CardsError(error.toString());
      }
    } else if (event is SelectCard) {
      try {
       
        yield IndexSelected(event.index);
      } catch (error) {
        yield CardsError(error);
      }
    }
   
  }
}
