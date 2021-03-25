part of 'ads_bloc.dart';

@immutable
abstract class AdsState {}


class ToShowAd extends AdsState{
  bool toShow;
  
  ToShowAd(this.toShow);
}