import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/transactions/transaction_model.dart';
import '../../infrastructure/transactions/transaction_service.dart';

part 'transaction_list_state.dart';

class TransactionListCubit extends Cubit<TransactionListState> {
  final TransactionService transactionService;

  TransactionListCubit({required this.transactionService})
      : super(const TransactionListInitial());

  Future<void> getTransactions({TransactionListFilter? filter}) async {
    try {
      emit(const TransactionListLoading());

      TransactionsServiceResponse response =
          await transactionService.getTransactions(filter: filter);

      if (response is GetTransactionsSuccessResponse) {
        emit(TransactionListLoaded(response.transactions));
      } else {
        emit(const TransactionListError());
      }
    } catch (e) {
      emit(const TransactionListError());
    }
  }

  void clearFilters() {
    if (state is TransactionListSearched) {
      List<Transaction> transactions = state.transactions;

      emit(TransactionListLoaded(transactions));
    }
  }

}
