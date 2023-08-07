import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/transactions/transaction_middleware.dart';
import 'package:solarisdemo/infrastructure/transactions/transaction_service.dart';
import 'package:solarisdemo/redux/app_reducer.dart';
import 'app_state.dart';

Store<AppState> createStore ({
  required AppState initialState,
  required TransactionService transactionService,
}){
  return Store<AppState>(
    appReducer,
    initialState: initialState,
    middleware: [
      GetTransactionsMiddleware(transactionService),
    ],
  );
}