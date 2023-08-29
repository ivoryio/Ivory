import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/bank_card/bank_card_middleware.dart';
import 'package:solarisdemo/infrastructure/bank_card/bank_card_service.dart';
import 'package:solarisdemo/infrastructure/categories/categories_middleware.dart';
import 'package:solarisdemo/infrastructure/categories/categories_service.dart';
import 'package:solarisdemo/infrastructure/credit_line/credit_line_middleware.dart';
import 'package:solarisdemo/infrastructure/credit_line/credit_line_service.dart';
import 'package:solarisdemo/infrastructure/notifications/notifications_middleware.dart';
import 'package:solarisdemo/infrastructure/notifications/push_notification_service.dart';
import 'package:solarisdemo/infrastructure/repayments/bills/bill_service.dart';
import 'package:solarisdemo/infrastructure/repayments/bills/bills_middleware.dart';
import 'package:solarisdemo/infrastructure/repayments/more_credit/more_credit_middleware.dart';
import 'package:solarisdemo/infrastructure/repayments/more_credit/more_credit_service.dart';
import 'package:solarisdemo/infrastructure/repayments/reminder/repayment_reminder_middleware.dart';
import 'package:solarisdemo/infrastructure/repayments/reminder/repayment_reminder_service.dart';
import 'package:solarisdemo/infrastructure/transactions/transaction_middleware.dart';
import 'package:solarisdemo/infrastructure/transactions/transaction_service.dart';
import 'package:solarisdemo/redux/app_reducer.dart';

import 'app_state.dart';

Store<AppState> createStore({
  required AppState initialState,
  required PushNotificationService pushNotificationService,
  required TransactionService transactionService,
  required CreditLineService creditLineService,
  required RepaymentReminderService repaymentReminderService,
  required BillService billService,
  required MoreCreditService moreCreditService,
  required BankCardService bankCardService,
  required CategoriesService categoriesService,
}) {
  return Store<AppState>(
    appReducer,
    initialState: initialState,
    middleware: [
      NotificationsMiddleware(pushNotificationService),
      GetTransactionsMiddleware(transactionService),
      GetCreditLineMiddleware(creditLineService),
      RepaymentRemindersMiddleware(repaymentReminderService),
      GetBillsMiddleware(billService),
      GetMoreCreditMiddleware(moreCreditService),
      BankCardMiddleware(bankCardService),
      GetCategoriesMiddleware(categoriesService),
    ],
  );
}
