import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/bank_card/bank_card_state.dart';
import 'package:solarisdemo/redux/categories/category_state.dart';
import 'package:solarisdemo/redux/credit_line/credit_line_state.dart';
import 'package:solarisdemo/redux/device/device_state.dart';
import 'package:solarisdemo/redux/notification/notification_state.dart';
import 'package:solarisdemo/redux/person/person_account/person_account_state.dart';
import 'package:solarisdemo/redux/person/reference_account/reference_account_state.dart';
import 'package:solarisdemo/redux/repayments/bills/bills_state.dart';
import 'package:solarisdemo/redux/repayments/more_credit/more_credit_state.dart';
import 'package:solarisdemo/redux/repayments/reminder/repayment_reminder_state.dart';
import 'package:solarisdemo/redux/transactions/approval/transaction_approval_state.dart';
import 'package:solarisdemo/redux/transactions/transactions_state.dart';
import 'package:solarisdemo/redux/transfer/transfer_state.dart';

AppState createAppState({
  TransactionsState? transactionsState,
  CreditLineState? creditLineState,
  RepaymentReminderState? repaymentReminderState,
  BillsState? billsState,
  MoreCreditState? moreCreditState,
  BankCardState? bankCardState,
  CategoriesState? categoriesState,
  ReferenceAccountState? referenceAccountState,
  PersonAccountState? personAccountState,
  TransferState? transferState,
  DeviceBindingState? deviceBindingState,
  NotificationState? notificationState,
  TransactionApprovalState? transactionApprovalState,
}) {
  return AppState(
    transactionsState: transactionsState ?? TransactionsInitialState(),
    creditLineState: creditLineState ?? CreditLineInitialState(),
    repaymentReminderState: repaymentReminderState ?? RepaymentReminderInitialState(),
    billsState: billsState ?? BillsInitialState(),
    moreCreditState: moreCreditState ?? MoreCreditInitialState(),
    bankCardState: bankCardState ?? BankCardInitialState(),
    categoriesState: categoriesState ?? CategoriesInitialState(),
    referenceAccountState: referenceAccountState ?? ReferenceAccountInitialState(),
    personAccountState: personAccountState ?? PersonAccountInitialState(),
    transferState: transferState ?? TransferInitialState(),
    deviceBindingState: deviceBindingState ?? DeviceBindingInitialState(),
    notificationState: notificationState ?? NotificationInitialState(),
    transactionApprovalState: transactionApprovalState ?? TransactionApprovalInitialState(),
  );
}
