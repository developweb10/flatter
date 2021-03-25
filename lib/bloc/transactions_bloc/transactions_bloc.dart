import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:krushapp/app/shared_prefrence.dart';
import '../../repositories/transactions_repository.dart';
import 'package:meta/meta.dart';

part 'transactions_event.dart';
part 'transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  TransactionsBloc() : super(TransactionsInitial());
  TransactionsRepository transactionsRepository = TransactionsRepository();
  @override
  Stream<TransactionsState> mapEventToState(
    TransactionsEvent event,
  ) async* {
    if (event is TransactionAdded) {
      yield TransactionsLoading();
      try {
        final result = await transactionsRepository
            .getTransactions(await UserSettingsManager.getStripeId());
        yield TransactionsLoaded(result);
      } catch (error) {
        yield TransactionsLoadingError(error.message);
      }
    }
  }

  @override
  // TODO: implement initialState
  TransactionsState get initialState => throw UnimplementedError();
}
