import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/bank_card/bank_card_state.dart';
import 'package:solarisdemo/redux/categories/category_state.dart';
import 'package:solarisdemo/redux/credit_line/credit_line_state.dart';
import 'package:solarisdemo/redux/device/device_state.dart';
import 'package:solarisdemo/redux/notification/notification_state.dart';
import 'package:solarisdemo/redux/onboarding/password/onboarding_password_state.dart';
import 'package:solarisdemo/redux/onboarding/signup/basic_info/onboarding_basic_info_state.dart';
import 'package:solarisdemo/redux/onboarding/signup/email/onboarding_email_state.dart';
import 'package:solarisdemo/redux/person/account_summary/account_summay_state.dart';
import 'package:solarisdemo/redux/person/person_account/person_account_state.dart';
import 'package:solarisdemo/redux/person/reference_account/reference_account_state.dart';
import 'package:solarisdemo/redux/repayments/bills/bills_state.dart';
import 'package:solarisdemo/redux/repayments/change_repayment/change_repayment_state.dart';
import 'package:solarisdemo/redux/repayments/more_credit/more_credit_state.dart';
import 'package:solarisdemo/redux/repayments/reminder/repayment_reminder_state.dart';
import 'package:solarisdemo/redux/transactions/approval/transaction_approval_state.dart';
import 'package:solarisdemo/redux/transactions/transactions_state.dart';
import 'package:solarisdemo/redux/transfer/transfer_state.dart';

AppState createAppState({
  TransactionsState? transactionsState,
  CreditLineState? creditLineState,
  RepaymentReminderState? repaymentReminderState,
  CardApplicationState? cardApplicationState,
  BillsState? billsState,
  MoreCreditState? moreCreditState,
  BankCardState? bankCardState,
  BankCardsState? bankCardsState,
  CategoriesState? categoriesState,
  ReferenceAccountState? referenceAccountState,
  PersonAccountState? personAccountState,
  TransferState? transferState,
  DeviceBindingState? deviceBindingState,
  NotificationState? notificationState,
  TransactionApprovalState? transactionApprovalState,
  AccountSummaryState? accountSummaryState,
  TransactionsState? homePageTransactionsState,
  OnboardingBasicInfoState? onboardingBasicInfoState,
  OnboardingEmailState? onboardingEmailState,
  OnboardingPasswordState? onboardingPasswordState,
}) {
  return AppState(
    transactionsState: transactionsState ?? TransactionsInitialState(),
    creditLineState: creditLineState ?? CreditLineInitialState(),
    repaymentReminderState: repaymentReminderState ?? RepaymentReminderInitialState(),
    cardApplicationState: cardApplicationState ?? CardApplicationInitialState(),
    billsState: billsState ?? BillsInitialState(),
    moreCreditState: moreCreditState ?? MoreCreditInitialState(),
    bankCardState: bankCardState ?? BankCardInitialState(),
    bankCardsState: bankCardsState ?? BankCardsInitialState(),
    categoriesState: categoriesState ?? CategoriesInitialState(),
    referenceAccountState: referenceAccountState ?? ReferenceAccountInitialState(),
    personAccountState: personAccountState ?? PersonAccountInitialState(),
    transferState: transferState ?? TransferInitialState(),
    deviceBindingState: deviceBindingState ?? DeviceBindingInitialState(),
    notificationState: notificationState ?? NotificationInitialState(),
    transactionApprovalState: transactionApprovalState ?? TransactionApprovalInitialState(),
    accountSummaryState: accountSummaryState ?? AccountSummaryInitialState(),
    homePageTransactionsState: homePageTransactionsState ?? TransactionsInitialState(),
    onboardingBasicInfoState: onboardingBasicInfoState ?? OnboardingBasicInfoInitialState(),
    onboardingEmailState: onboardingEmailState ?? OnboardingEmailInitialState(),
    onboardingPasswordState: onboardingPasswordState ?? OnboardingPasswordInitialState(),
  );
}
