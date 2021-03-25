import 'dart:async';

import 'package:bloc/bloc.dart';
import '../../app/shared_prefrence.dart';
import 'package:meta/meta.dart';

part 'ads_event.dart';
part 'ads_state.dart';

class AdsBloc extends Bloc<AdsEvent, AdsState> {

 AdsBloc() : super(ToShowAd(false));

  @override
  Stream<AdsState> mapEventToState(
    AdsEvent event,
  ) async* {
    if (event is CheckToShowAd) {
      try {
        int result1 = await UserSettingsManager.getSubsciptionStatus();
        if (result1 == 1) {
          yield ToShowAd(false);
        }else{
          yield ToShowAd(true);
        }
      } catch (error) {}
    }
  

  }
}
