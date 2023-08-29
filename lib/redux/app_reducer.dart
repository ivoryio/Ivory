import 'package:solarisdemo/redux/bank_card/bank_card_reducer.dart';
import 'package:solarisdemo/redux/categories/category_reducer.dart';
import 'package:solarisdemo/redux/credit_line/credit_line_reducer.dart';
import 'package:solarisdemo/redux/repayments/bills/bills_reducer.dart';
import 'package:solarisdemo/redux/repayments/more_credit/more_credit_reducer.dart';
import 'package:solarisdemo/redux/repayments/reminder/repayment_reminder_reducer.dart';
import 'package:solarisdemo/redux/transactions/transactions_reducer.dart';

import 'app_state.dart';

AppState appReducer(AppState currentState, dynamic action) {
  return AppState(
    transactionsState:
        transactionsReducer(currentState.transactionsState, action),
    creditLineState: creditLineReducer(currentState.creditLineState, action),
    repaymentReminderState:
        repaymentReminderReducer(currentState.repaymentReminderState, action),
    billsState: billsReducer(currentState.billsState, action),
    moreCreditState: moreCreditReducer(currentState.moreCreditState, action),
    bankCardState: bankCardReducer(currentState.bankCardState, action),
    categoriesState: categoriesReducer(currentState.categoriesState, action),
  );
}
