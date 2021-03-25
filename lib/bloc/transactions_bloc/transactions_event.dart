part of 'transactions_bloc.dart';

@immutable
abstract class TransactionsEvent {}

class TransactionAdded extends TransactionsEvent {
  final List transactions;

  TransactionAdded({this.transactions});

  @override
  String toString() => "SearchTextChanged { query: ${transactions.toString} }";
}
