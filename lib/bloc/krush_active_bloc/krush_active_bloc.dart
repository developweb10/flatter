import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../app/api.dart';
import '../../app/shared_prefrence.dart';
import '../../model/recieve_request.dart';
import '../../repositories/krush_recieved_repository.dart';
import 'package:meta/meta.dart';
part 'krush_active_event.dart';
part 'krush_active_state.dart';

class KrushActiveBloc extends Bloc<KrushActiveBlocEvent, KrushActiveBlocState> {
  ApiClient _client;

  KrushActiveBloc() : super(SearchStateLoading());

  KrushRecievedRepository krushRecievedRepository = KrushRecievedRepository();
  @override
  void onTransition(
      Transition<KrushActiveBlocEvent, KrushActiveBlocState> transition) {
 
    super.onTransition(transition);
  }

  @override
  Stream<KrushActiveBlocState> mapEventToState(
    KrushActiveBlocEvent event,
  ) async* {
    if (event is ListChanged) {
      //  yield SearchStateLoading();
      try {
        final result = await krushRecievedRepository.getRecievedRequests( "accepted");
        
        yield SearchStateSuccess(result);
      } catch (error) {
        yield SearchStateError(error);
      }
    }
  }
}
