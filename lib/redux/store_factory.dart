import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/credit_line/credit_line_middleware.dart';
import 'package:solarisdemo/infrastructure/credit_line/credit_line_service.dart';
import 'package:solarisdemo/infrastructure/notifications/notifications_middleware.dart';
import 'package:solarisdemo/infrastructure/notifications/push_notification_service.dart';
import 'package:solarisdemo/infrastructure/repayments/reminder/repayment_reminder_middleware.dart';
import 'package:solarisdemo/infrastructure/repayments/reminder/repayment_reminder_service.dart';
import 'package:solarisdemo/infrastructure/transactions/transaction_middleware.dart';
import 'package:solarisdemo/infrastructure/transactions/transaction_service.dart';
import 'package:solarisdemo/redux/app_reducer.dart';

import '../infrastructure/bank_card/activation/bank_card_activation_middleware.dart';
import '../infrastructure/bank_card/activation/bank_card_activation_service.dart';
import 'app_state.dart';

Store<AppState> createStore({
  required AppState initialState,
  required PushNotificationService pushNotificationService,
  required TransactionService transactionService,
  required CreditLineService creditLineService,
  required RepaymentReminderService repaymentReminderService,
  required BankCardActivationService bankCardActivationService,
}) {
  return Store<AppState>(
    appReducer,
    initialState: initialState,
    middleware: [
      NotificationsMiddleware(pushNotificationService),
      GetTransactionsMiddleware(transactionService),
      GetCreditLineMiddleware(creditLineService),
      RepaymentRemindersMiddleware(repaymentReminderService),
      BankCardActivationMiddleware(bankCardActivationService),
    ],
  );
}
