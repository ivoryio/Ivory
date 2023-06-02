import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/transaction_model.dart';
import '../../services/transaction_service.dart';

part 'transaction_list_state.dart';

class TransactionListCubit extends Cubit<TransactionListState> {
  final TransactionService transactionService;

  TransactionListCubit({required this.transactionService})
      : super(const TransactionListInitial());

  Future<void> getTransactions({TransactionListFilter? filter}) async {
    try {
      emit(const TransactionListLoading());

      List<Transaction>? transactions =
          await transactionService.getTransactions(filter: filter);

      if (transactions is List<Transaction>) {
        emit(TransactionListLoaded(transactions));
      } else {
        emit(const TransactionListInitial());
      }
    } catch (e) {
      emit(const TransactionListError());
    }
  }

  void searchTransactions(String searchTerm) async {
    if (state is TransactionListLoaded || state is TransactionListSearched) {
      List<Transaction> transactions = state.transactions;

      emit(TransactionListLoading(transactions: transactions));

      List<Transaction> filteredTransactions = transactions
          .where(
            (transaction) =>
                transaction.description!
                    .toLowerCase()
                    .contains(_checkSearchTerm(searchTerm)) ||
                transaction.recipientName!
                    .toLowerCase()
                    .contains(_checkSearchTerm(searchTerm)),
          )
          .toList();

      emit(
        TransactionListSearched(
            filteredTransactions: filteredTransactions,
            transactions: transactions),
      );
    }
  }

  void clearFilters() {
    if (state is TransactionListSearched) {
      List<Transaction> transactions = state.transactions;

      emit(TransactionListLoaded(transactions));
    }
  }

  String _checkSearchTerm(String searchTerm) {
    searchTerm = searchTerm.toLowerCase().trim();

    return searchTerm;
  }
}
