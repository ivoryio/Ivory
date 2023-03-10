import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:solaris_structure_1/services/transaction_service.dart';

import '../../models/transaction.dart';

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
