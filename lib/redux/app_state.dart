import 'package:equatable/equatable.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/bank_card/bank_card_state.dart';
import 'package:solarisdemo/redux/categories/category_state.dart';
import 'package:solarisdemo/redux/credit_line/credit_line_state.dart';
import 'package:solarisdemo/redux/device/device_state.dart';
import 'package:solarisdemo/redux/documents/confirm/confirm_documents_state.dart';
import 'package:solarisdemo/redux/documents/documents_state.dart';
import 'package:solarisdemo/redux/documents/download/download_document_state.dart';
import 'package:solarisdemo/redux/notification/notification_state.dart';
import 'package:solarisdemo/redux/onboarding/card_configuration/onboarding_card_configuration_state.dart';
import 'package:solarisdemo/redux/onboarding/financial_details/onboarding_financial_details_state.dart';
import 'package:solarisdemo/redux/onboarding/identity_verification/onboarding_identity_verification_state.dart';
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
import 'package:solarisdemo/redux/top_up/add_card_state.dart';
import 'package:solarisdemo/redux/transactions/approval/transaction_approval_state.dart';
import 'package:solarisdemo/redux/transactions/transactions_state.dart';
import 'package:solarisdemo/redux/transfer/transfer_state.dart';

class AppState extends Equatable {
  final TransactionsState transactionsState;
  final CreditLineState creditLineState;
  final RepaymentReminderState repaymentReminderState;
  final CardApplicationState cardApplicationState;
  final BillsState billsState;
  final MoreCreditState moreCreditState;
  final BankCardState bankCardState;
  final BankCardsState bankCardsState;
  final CategoriesState categoriesState;
  final ReferenceAccountState referenceAccountState;
  final PersonAccountState personAccountState;
  final AddCardInfoState addCardInfoState;
  final TransferState transferState;
  final DeviceBindingState deviceBindingState;
  final NotificationState notificationState;
  final TransactionApprovalState transactionApprovalState;
  final AccountSummaryState accountSummaryState;
  final AuthState authState;
  final TransactionsState homePageTransactionsState;
  final OnboardingProgressState onboardingProgressState;
  final OnboardingSignupState onboardingSignupState;
  final OnboardingPersonalDetailsState onboardingPersonalDetailsState;
  final CitySuggestionsState citySuggestionsState;
  final AddressSuggestionsState addressSuggestionsState;
  final OnboardingFinancialDetailsState onboardingFinancialDetailsState;
  final DocumentsState documentsState;
  final DownloadDocumentState downloadDocumentState;
  final ConfirmDocumentsState confirmDocumentsState;
  final OnboardingIdentityVerificationState onboardingIdentityVerificationState;
  final OnboardingCardConfigurationState onboardingCardConfigurationState;

  const AppState({
    required this.transactionsState,
    required this.creditLineState,
    required this.repaymentReminderState,
    required this.cardApplicationState,
    required this.billsState,
    required this.moreCreditState,
    required this.bankCardState,
    required this.bankCardsState,
    required this.categoriesState,
    required this.referenceAccountState,
    required this.personAccountState,
    required this.addCardInfoState,
    required this.transferState,
    required this.deviceBindingState,
    required this.notificationState,
    required this.transactionApprovalState,
    required this.accountSummaryState,
    required this.authState,
    required this.homePageTransactionsState,
    required this.onboardingSignupState,
    required this.onboardingProgressState,
    required this.onboardingPersonalDetailsState,
    required this.citySuggestionsState,
    required this.addressSuggestionsState,
    required this.onboardingFinancialDetailsState,
    required this.documentsState,
    required this.downloadDocumentState,
    required this.confirmDocumentsState,
    required this.onboardingIdentityVerificationState,
    required this.onboardingCardConfigurationState,
  });

  factory AppState.initialState() {
    return AppState(
      transactionsState: TransactionsInitialState(),
      creditLineState: CreditLineInitialState(),
      repaymentReminderState: RepaymentReminderInitialState(),
      cardApplicationState: CardApplicationInitialState(),
      billsState: BillsInitialState(),
      moreCreditState: MoreCreditInitialState(),
      bankCardState: BankCardInitialState(),
      bankCardsState: BankCardsInitialState(),
      categoriesState: CategoriesInitialState(),
      referenceAccountState: ReferenceAccountInitialState(),
      personAccountState: PersonAccountInitialState(),
      addCardInfoState: AddCardInfoInitialState(),
      transferState: TransferInitialState(),
      deviceBindingState: DeviceBindingInitialState(),
      notificationState: NotificationInitialState(),
      transactionApprovalState: TransactionApprovalInitialState(),
      accountSummaryState: AccountSummaryInitialState(),
      authState: AuthInitialState(),
      homePageTransactionsState: TransactionsInitialState(),
      onboardingSignupState: const OnboardingSignupState(),
      onboardingProgressState: OnboardingProgressInitialLoadingState(),
      onboardingPersonalDetailsState: const OnboardingPersonalDetailsState(),
      citySuggestionsState: CitySuggestionsInitialState(),
      addressSuggestionsState: AddressSuggestionsInitialState(),
      onboardingFinancialDetailsState: const OnboardingFinancialDetailsState(),
      documentsState: DocumentsInitialLoadingState(),
      downloadDocumentState: DownloadDocumentInitialState(),
      confirmDocumentsState: ConfirmDocumentsInitialState(),
      onboardingIdentityVerificationState: const OnboardingIdentityVerificationState(),
      onboardingCardConfigurationState: OnboardingCardConfigurationInitialState(),
    );
  }

  @override
  List<Object?> get props => [
        transactionsState,
        creditLineState,
        repaymentReminderState,
        cardApplicationState,
        billsState,
        moreCreditState,
        bankCardState,
        bankCardsState,
        categoriesState,
        referenceAccountState,
        personAccountState,
        addCardInfoState,
        transferState,
        deviceBindingState,
        notificationState,
        transactionApprovalState,
        accountSummaryState,
        authState,
        homePageTransactionsState,
        onboardingSignupState,
        onboardingProgressState,
        onboardingPersonalDetailsState,
        citySuggestionsState,
        addressSuggestionsState,
        onboardingFinancialDetailsState,
        documentsState,
        downloadDocumentState,
        confirmDocumentsState,
        onboardingIdentityVerificationState,
        onboardingCardConfigurationState,
      ];

  @override
  bool get stringify => true;
}
