import 'package:solarisdemo/redux/transactions/transactions_reducer.dart';

import 'app_state.dart';

AppState appReducer(AppState currentState, dynamic action) {
  return AppState(
    transactionsState: transactionsReducer(currentState.transactionsState, action),
  );
}