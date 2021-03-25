import 'dart:async';

import 'package:bloc/bloc.dart';
import '../../app/api.dart';
import '../../app/shared_prefrence.dart';
import '../../model/sent_request.dart';
import '../../repositories/krush_sent_repository.dart';
import 'package:meta/meta.dart';

part 'krush_sent_bloc_event.dart';
part 'krush_sent_bloc_state.dart';

class KrushSentBloc extends Bloc<KrushSentBlocEvent, KrushSentBlocState> {
  ApiClient _client;
  final KrushSentRepository krushSentRepository = KrushSentRepository();
  KrushSentBloc() : super(SearchStateLoading());

  @override
  void onTransition(
      Transition<KrushSentBlocEvent, KrushSentBlocState> transition) {
 
    super.onTransition(transition);
  }

  @override
  Stream<KrushSentBlocState> mapEventToState(
    KrushSentBlocEvent event,
  ) async* {
    if (event is KrushSentListChanged) {
      // yield SearchStateLoading();
      try {
        final result = await krushSentRepository
            .getSentRequests();
     
        yield SearchStateSuccess(result);
      } catch (error) {
        yield SearchStateError(error);
      }
    }
  }

//   Stream<KrushSentBlocState> _mapListChangedToState(ListChanged event) async* {

// }

}
