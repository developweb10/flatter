import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bottom_nav_counters_event.dart';
part 'bottom_nav_counters_state.dart';

class BottomNavCountersBloc
    extends Bloc<BottomNavCountersEvent, BottomNavCountersState> {
  BottomNavCountersBloc()
      : super(BottomNavCountersUpdated(
            chatsCounter: 0, giftsCounter: 0, krushesCounter: 0));
  int chatsCounter = 0;
  int krushesCounter = 0;
  int giftsCounter = 0;

  @override
  Stream<BottomNavCountersState> mapEventToState(
    BottomNavCountersEvent event,
  ) async* {
    if (event is UpdateCountersEvent) {
    
      if (event.chatsCounter != null) {
        chatsCounter = event.chatsCounter;
      } else if (event.giftsCounter != null) {
        giftsCounter = event.giftsCounter;
      } else if (event.krushesCounter != null) {
        krushesCounter = event.krushesCounter;
      }
      yield BottomNavCountersUpdated(
          chatsCounter: chatsCounter,
          giftsCounter: giftsCounter,
          krushesCounter: krushesCounter);
    }
  }
}
