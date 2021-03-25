import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../app/api.dart';
import '../../app/shared_prefrence.dart';
import '../../model/recieve_request.dart';
import '../../repositories/krush_recieved_repository.dart';
import 'package:meta/meta.dart';
part 'krush_recieved_bloc_event.dart';
part 'krush_recieved_recieved_bloc_state.dart';

class KrushRequestBloc
    extends Bloc<KrushRequestBlocEvent, KrushRequestBlocState> {
  ApiClient _client;

  KrushRequestBloc() : super(KrushRequestLoading());

  KrushRecievedRepository krushRecievedRepository = KrushRecievedRepository();
  @override
  void onTransition(
      Transition<KrushRequestBlocEvent, KrushRequestBlocState> transition) {

    super.onTransition(transition);
  }

  @override
  Stream<KrushRequestBlocState> mapEventToState(
    KrushRequestBlocEvent event,
  ) async* {
    if (event is KrushRequestListChanged) {
      //  yield KrushRequestLoading();
      try {
        final result = await krushRecievedRepository.getRecievedRequests( "pending");

        yield KrushRequestSuccess(result);
      } catch (error) {
        yield KrushRequestError(error);
      }
    }
  }
}
