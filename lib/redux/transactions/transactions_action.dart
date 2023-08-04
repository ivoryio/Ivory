import '../../models/transaction_model.dart';
import '../../infrastructure/transactions/transaction_service.dart';
import '../../models/user.dart';

class GetTransactionsCommandAction {
  final TransactionListFilter? filter;
  final User user;

  GetTransactionsCommandAction({required this.filter, required this.user});
}

class TransactionsLoadingEventAction {}
class TransactionsFailedEventAction {}

class TransactionsFetchedEventAction{
  final List<Transaction> transactions;
  final TransactionListFilter? transactionListFilter;

  TransactionsFetchedEventAction({required this.transactions, this.transactionListFilter});
}