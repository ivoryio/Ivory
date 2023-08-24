import 'package:solarisdemo/redux/categories/category_reducer.dart';
import 'package:solarisdemo/redux/person/reference_account_reducer.dart';
import 'package:solarisdemo/redux/repayments/reminder/repayment_reminder_reducer.dart';
import 'package:solarisdemo/redux/transactions/transactions_reducer.dart';

import 'app_state.dart';
import 'bank_card/bank_card_reducer.dart';
import 'credit_line/credit_line_reducer.dart';

AppState appReducer(AppState currentState, dynamic action) {
  return AppState(
    transactionsState: transactionsReducer(currentState.transactionsState, action),
    creditLineState: creditLineReducer(currentState.creditLineState, action),
    repaymentReminderState: repaymentReminderReducer(currentState.repaymentReminderState, action),
    bankCardState: bankCardReducer(currentState.bankCardState, action),
    categoriesState: categoriesReducer(currentState.categoriesState, action),
    referenceAccountState: referenceAccountReducer(currentState.referenceAccountState, action),
  );
}
