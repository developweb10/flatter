part of 'transactions_bloc.dart';

@immutable
abstract class TransactionsState {}

class TransactionsInitial extends TransactionsState {}


class TransactionsLoading extends TransactionsState {
  @override
  String toString() => 'TransactionsLoading';
}

class TransactionsLoaded extends TransactionsState {
  final List transactionsList;

  TransactionsLoaded(this.transactionsList);


  @override
  String toString() => 'SearchStateSuccess { songs: ${transactionsList.toString()} }';
}

class TransactionsLoadingError extends TransactionsState {
  final String error;

  TransactionsLoadingError(this.error);

  @override
  String toString() => 'SearchStateError { error: $error }';
}