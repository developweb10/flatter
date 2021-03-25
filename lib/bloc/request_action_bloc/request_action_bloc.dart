import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:krushapp/repositories/request_action_repository.dart';
import '../krushin_coins_bloc/krushin_coins_bloc.dart';
import '../../model/result.dart';
import '../../app/shared_prefrence.dart';
import '../../model/aviator_model.dart';
import 'package:meta/meta.dart';
import 'package:flutter/cupertino.dart';
import '../../model/aviator_model.dart';

part 'request_action_event.dart';
part 'request_action_state.dart';

class RequestActionBloc extends Bloc<RequestActionEvent, RequestActionState> {
  // ApiClient _client;
  final RequestActionRepository requestActionRepository =
      RequestActionRepository();
  RequestActionBloc() : super(RequestActionStateLoading());

  @override
  RequestActionState get initialState => RequestActionStateLoading();

  @override
  Stream<RequestActionState> mapEventToState(
    RequestActionEvent event,
  ) async* {
    if (event is CheckAcceptKrush) {
      try {
        if (await requestActionRepository.subscribed() == 0) {
          if (!(await requestActionRepository.freeAcceptRequestsAllowed())) {
            yield RequestActionStateFreeRequestsNotEnough();
          } else {
            yield RequestActionStateOkToSend();
          }
        } else {
          yield SubscribedOkToAccept();
        }
      } catch (error) {
        yield RequestActionStateError(error.message);
      }
    } else if (event is RequestAction) {
      yield RequestActionStateLoading();
      try {
        Result result = await requestActionRepository.applyAction(
            event.relationId,
            event.uri,
            await UserSettingsManager.getUserToken());
        if (result.status) {
          UserSettingsManager.setFreeAcceptRequestsAllowed(
              result.data.freeAcceptsAvailable);

          yield RequestActionStateSuccess();
        } else {
          yield RequestActionStateError(result.message);
        }
      } catch (error) {
        yield RequestActionStateError(error);
      }
    }
  }
}
