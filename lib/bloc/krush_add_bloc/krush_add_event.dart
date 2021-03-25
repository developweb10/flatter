part of 'krush_add_bloc.dart';



@immutable
abstract class KrushAddEvent {}

class CheckAddKrush extends KrushAddEvent {

  CheckAddKrush();

  @override
  String toString() => "SearchTextChanged { query:}";
}


class KrushAdd extends KrushAddEvent {
  final String phoneNumber;
  final String chatName;
  final String krushName;
  final String comment;
  final String aviator;

  KrushAdd(this.phoneNumber, this.chatName, this.krushName, this.comment, this.aviator);

  @override
  String toString() => "SearchTextChanged { query:}";
}

class Subsciption extends KrushAddEvent {

  @override
  String toString() => "SearchTextChanged { query:}";
}