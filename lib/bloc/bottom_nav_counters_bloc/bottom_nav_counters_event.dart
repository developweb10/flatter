part of 'bottom_nav_counters_bloc.dart';

abstract class BottomNavCountersEvent {}

class UpdateCountersEvent extends BottomNavCountersEvent {
  final int chatsCounter;
  final int krushesCounter;
  final int giftsCounter;
  UpdateCountersEvent(
      {this.chatsCounter, this.krushesCounter, this.giftsCounter});
}
