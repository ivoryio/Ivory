import '../../models/transaction_model.dart';
import '../../infrastructure/transactions/transaction_service.dart';

class GetTransactionsCommandAction {
  final TransactionListFilter? filter;

  GetTransactionsCommandAction({required this.filter});
}

class TransactionsLoadingEventAction {}
class TransactionsFailedEventAction {}

class TransactionsFetchedEventAction{
  final List<Transaction> transactions;

  TransactionsFetchedEventAction({required this.transactions});
}