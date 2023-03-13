import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/transaction_model.dart';
import '../../services/transaction_service.dart';

part 'transaction_list_state.dart';

class TransactionListCubit extends Cubit<TransactionListState> {
  final TransactionService transactionService;

  TransactionListCubit({required this.transactionService})
      : super(const TransactionListInitial());

  Future<void> getTransactions() async {
    try {
      emit(const TransactionListLoading());
      List<Transaction>? transactions =
          await transactionService.getTransactions();
      if (transactions is List<Transaction>) {
        emit(TransactionListLoaded(transactions));
      } else {
        emit(const TransactionListInitial());
      }
    } catch (e) {
      emit(const TransactionListError());
    }
  }
}
