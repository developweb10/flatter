part of 'bottom_nav_counters_bloc.dart';

abstract class BottomNavCountersState {}

class BottomNavCountersUpdated extends BottomNavCountersState {
  final int chatsCounter;
  final int krushesCounter;
  final int giftsCounter;
  BottomNavCountersUpdated(
      {this.chatsCounter, this.giftsCounter, this.krushesCounter});
}
