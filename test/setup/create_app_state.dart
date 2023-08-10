import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/credit_line/credit_line_state.dart';
import 'package:solarisdemo/redux/transactions/transactions_state.dart';

AppState createAppState({
  TransactionsState? transactionsState,
  CreditLineState? creditLineState,
}) {
  return AppState(
    transactionsState: transactionsState ?? TransactionsInitialState(),
    creditLineState: creditLineState ?? CreditLineInitialState(),
  );
}