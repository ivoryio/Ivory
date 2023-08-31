import 'package:solarisdemo/redux/bank_card/bank_card_reducer.dart';
import 'package:solarisdemo/redux/categories/category_reducer.dart';
import 'package:solarisdemo/redux/credit_line/credit_line_reducer.dart';
import 'package:solarisdemo/redux/notification/notification_reducer.dart';
import 'package:solarisdemo/redux/person/person_account/person_account_reducer.dart';
import 'package:solarisdemo/redux/person/reference_account/reference_account_reducer.dart';
import 'package:solarisdemo/redux/repayments/bills/bills_reducer.dart';
import 'package:solarisdemo/redux/repayments/reminder/repayment_reminder_reducer.dart';
import 'package:solarisdemo/redux/transactions/transactions_reducer.dart';
import 'package:solarisdemo/redux/transfer/transfer_reducer.dart';

import 'app_state.dart';

AppState appReducer(AppState currentState, dynamic action) {
  return AppState(
    transactionsState: transactionsReducer(currentState.transactionsState, action),
    creditLineState: creditLineReducer(currentState.creditLineState, action),
    repaymentReminderState: repaymentReminderReducer(currentState.repaymentReminderState, action),
    billsState: billsReducer(currentState.billsState, action),
    bankCardState: bankCardReducer(currentState.bankCardState, action),
    categoriesState: categoriesReducer(currentState.categoriesState, action),
    referenceAccountState: referenceAccountReducer(currentState.referenceAccountState, action),
    personAccountState: personAccountReducer(currentState.personAccountState, action),
    transferState: transferReducer(currentState.transferState, action),
    notificationState: notificationReducer(currentState.notificationState, action),
  );
}
