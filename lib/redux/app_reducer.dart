import 'package:solarisdemo/redux/bank_card/activation/bank_card_activation_reducer.dart';
import 'package:solarisdemo/redux/repayments/reminder/repayment_reminder_reducer.dart';
import 'package:solarisdemo/redux/transactions/transactions_reducer.dart';

import 'app_state.dart';
import 'credit_line/credit_line_reducer.dart';

AppState appReducer(AppState currentState, dynamic action) {
  return AppState(
    transactionsState: transactionsReducer(currentState.transactionsState, action),
    creditLineState: creditLineReducer(currentState.creditLineState, action),
    repaymentReminderState: repaymentReminderReducer(currentState.repaymentReminderState, action),
    bankCardActivationState: bankCardActivationReducer(currentState.bankCardActivationState, action)
  );
}
