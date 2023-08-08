import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/transactions/transactions_state.dart';

AppState createAppState({
  TransactionsState? transactionsState,
}) {
  return AppState(
      transactionsState: transactionsState ?? TransactionsInitialState(),
  );
}