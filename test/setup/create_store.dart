import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/transactions/transaction_service.dart';
import 'package:solarisdemo/models/transaction_model.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/store_factory.dart';

Store<AppState> createTestStore({
  required AppState initialState,
  TransactionService? transactionService,
}) {
  return createStore(
      initialState: initialState,
      transactionService: transactionService ?? NotImplementedTransactionService(),
  );
}

class NotImplementedTransactionService extends TransactionService {
  @override
  Future<TransactionsServiceResponse> getTransactions({TransactionListFilter? filter, User? user}) {
    throw(UnimplementedError);
  }
}