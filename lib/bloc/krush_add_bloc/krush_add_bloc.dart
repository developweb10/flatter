import 'dart:async';

import 'package:bloc/bloc.dart';
import '../../model/result.dart';
import '../../app/shared_prefrence.dart';
import '../../repositories/krush_add_repository.dart';
import 'package:meta/meta.dart';
import 'package:flutter/cupertino.dart';

part 'krush_add_event.dart';
part 'krush_add_state.dart';

class KrushAddBloc extends Bloc<KrushAddEvent, KrushAddState> {
  // ApiClient _client;
  final KrushAddRepository krushAddRepository = KrushAddRepository();
  KrushAddBloc() : super(KrushAddStateLoading());

  @override
  KrushAddState get initialState => KrushAddStateLoading();

  @override
  Stream<KrushAddState> mapEventToState(
    KrushAddEvent event,
  ) async* {
    if (event is CheckAddKrush) {
      try {
        if (await krushAddRepository.subscribed() == 0) {
          if (!(await krushAddRepository.freeSendRequestsEnough())) {
               yield KrushAddStateFreeRequestsNotEnough();
          } else {
            yield KrushAddStateOkToSend();
          }
        } else {
          yield SubscribedOkToAdd();
        }
      } catch (error) {
        yield KrushAddStateError(error.message);
      }
    } else if (event is KrushAdd) {
      yield KrushAddStateLoading();
      try {
        Result result = await krushAddRepository.sendRequest(
          event.phoneNumber,
          event.chatName,
          event.krushName,
          event.comment,
          event.aviator,
        );
        if (result.status) {
          UserSettingsManager.setFreesendRequestssAllowed(
              result.data.freeSendRequestAvailable);
          yield KrushAddStateSuccess();
        } else {
          yield KrushAddStateError(result.reason);
        }
      } catch (error) {
        yield KrushAddStateError(error.message);
      }
    }
  }
}
