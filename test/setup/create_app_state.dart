import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/bank_card/bank_card_state.dart';
import 'package:solarisdemo/redux/categories/category_state.dart';
import 'package:solarisdemo/redux/credit_line/credit_line_state.dart';
import 'package:solarisdemo/redux/device/device_state.dart';
import 'package:solarisdemo/redux/documents/documents_state.dart';
import 'package:solarisdemo/redux/documents/download/download_document_state.dart';
import 'package:solarisdemo/redux/notification/notification_state.dart';
import 'package:solarisdemo/redux/onboarding/financial_details/onboarding_financial_details_state.dart';
import 'package:solarisdemo/redux/onboarding/onboarding_progress_state.dart';
import 'package:solarisdemo/redux/onboarding/personal_details/onboarding_personal_details_state.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_state.dart';
import 'package:solarisdemo/redux/person/account_summary/account_summay_state.dart';
import 'package:solarisdemo/redux/person/person_account/person_account_state.dart';
import 'package:solarisdemo/redux/person/reference_account/reference_account_state.dart';
import 'package:solarisdemo/redux/repayments/bills/bills_state.dart';
import 'package:solarisdemo/redux/repayments/change_repayment/change_repayment_state.dart';
import 'package:solarisdemo/redux/repayments/more_credit/more_credit_state.dart';
import 'package:solarisdemo/redux/repayments/reminder/repayment_reminder_state.dart';
import 'package:solarisdemo/redux/suggestions/address/address_suggestions_state.dart';
import 'package:solarisdemo/redux/suggestions/city/city_suggestions_state.dart';
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
  AuthState? authState,
  TransactionsState? homePageTransactionsState,
  OnboardingProgressState? onboardingProgressState,
  OnboardingSignupState? onboardingSignupState,
  OnboardingPersonalDetailsState? onboardingPersonalDetailsState,
  CitySuggestionsState? citySuggestionsState,
  AddressSuggestionsState? addressSuggestionsState,
  OnboardingFinancialDetailsState? onboardingFinancialDetailsState,
  DocumentsState? documentsState,
  DownloadDocumentState? downloadDocumentState,
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
    authState: authState ?? AuthInitialState(),
    homePageTransactionsState: homePageTransactionsState ?? TransactionsInitialState(),
    onboardingProgressState: onboardingProgressState ?? OnboardingProgressInitialLoadingState(),
    onboardingSignupState: onboardingSignupState ?? const OnboardingSignupState(),
    onboardingPersonalDetailsState: onboardingPersonalDetailsState ?? const OnboardingPersonalDetailsState(),
    citySuggestionsState: citySuggestionsState ?? CitySuggestionsInitialState(),
    addressSuggestionsState: addressSuggestionsState ?? AddressSuggestionsInitialState(),
    onboardingFinancialDetailsState: onboardingFinancialDetailsState ?? const OnboardingFinancialDetailsState(),
    documentsState: documentsState ?? DocumentsInitialLoadingState(),
    downloadDocumentState: downloadDocumentState ?? DownloadDocumentInitialState(),
  );
}
