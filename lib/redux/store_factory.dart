import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/auth/auth_middleware.dart';
import 'package:solarisdemo/infrastructure/auth/auth_service.dart';
import 'package:solarisdemo/infrastructure/bank_card/bank_card_middleware.dart';
import 'package:solarisdemo/infrastructure/bank_card/bank_card_service.dart';
import 'package:solarisdemo/infrastructure/categories/categories_middleware.dart';
import 'package:solarisdemo/infrastructure/categories/categories_service.dart';
import 'package:solarisdemo/infrastructure/change_request/change_request_service.dart';
import 'package:solarisdemo/infrastructure/common/action_logger_middleware.dart';
import 'package:solarisdemo/infrastructure/credit_line/credit_line_middleware.dart';
import 'package:solarisdemo/infrastructure/credit_line/credit_line_service.dart';
import 'package:solarisdemo/infrastructure/device/biometrics_service.dart';
import 'package:solarisdemo/infrastructure/device/device_fingerprint_service.dart';
import 'package:solarisdemo/infrastructure/device/device_middleware.dart';
import 'package:solarisdemo/infrastructure/device/device_binding_service.dart';
import 'package:solarisdemo/infrastructure/device/device_service.dart';
import 'package:solarisdemo/infrastructure/documents/documents_middleware.dart';
import 'package:solarisdemo/infrastructure/documents/documents_service.dart';
import 'package:solarisdemo/infrastructure/documents/file_saver_service.dart';
import 'package:solarisdemo/infrastructure/mobile_number/mobile_number_service.dart';
import 'package:solarisdemo/infrastructure/notifications/notifications_middleware.dart';
import 'package:solarisdemo/infrastructure/notifications/push_notification_service.dart';
import 'package:solarisdemo/infrastructure/onboarding/card_configuration/onboarding_card_configuration_middleware.dart';
import 'package:solarisdemo/infrastructure/onboarding/card_configuration/onboarding_card_configuration_service.dart';
import 'package:solarisdemo/infrastructure/onboarding/financial_details/onboarding_financial_details_middleware.dart';
import 'package:solarisdemo/infrastructure/onboarding/financial_details/onboarding_financial_details_service.dart';
import 'package:solarisdemo/infrastructure/onboarding/identity_verification/onboarding_identity_verification_middleware.dart';
import 'package:solarisdemo/infrastructure/onboarding/identity_verification/onboarding_identity_verification_service.dart';
import 'package:solarisdemo/infrastructure/onboarding/personal_details/onboarding_personal_details_service.dart';
import 'package:solarisdemo/infrastructure/onboarding/signup/onboarding_signup_middleware.dart';
import 'package:solarisdemo/infrastructure/onboarding/onboarding_progress_middleware.dart';
import 'package:solarisdemo/infrastructure/onboarding/onboarding_service.dart';
import 'package:solarisdemo/infrastructure/onboarding/signup/onboarding_signup_service.dart';
import 'package:solarisdemo/infrastructure/onboarding/personal_details/onboarding_personal_details_middleware.dart';
import 'package:solarisdemo/infrastructure/person/account_summary/account_summary_middleware.dart';
import 'package:solarisdemo/infrastructure/person/account_summary/account_summary_service.dart';
import 'package:solarisdemo/infrastructure/person/person_account_middleware.dart';
import 'package:solarisdemo/infrastructure/person/person_service.dart';
import 'package:solarisdemo/infrastructure/person/reference_account_middleware.dart';
import 'package:solarisdemo/infrastructure/repayments/bills/bill_service.dart';
import 'package:solarisdemo/infrastructure/repayments/bills/bills_middleware.dart';
import 'package:solarisdemo/infrastructure/repayments/change_repayment/change_repayment_middleware.dart';
import 'package:solarisdemo/infrastructure/repayments/change_repayment/change_repayment_service.dart';
import 'package:solarisdemo/infrastructure/repayments/more_credit/more_credit_middleware.dart';
import 'package:solarisdemo/infrastructure/repayments/more_credit/more_credit_service.dart';
import 'package:solarisdemo/infrastructure/repayments/reminder/repayment_reminder_middleware.dart';
import 'package:solarisdemo/infrastructure/repayments/reminder/repayment_reminder_service.dart';
import 'package:solarisdemo/infrastructure/suggestions/address/address_suggestions_middleware.dart';
import 'package:solarisdemo/infrastructure/suggestions/address/address_suggestions_service.dart';
import 'package:solarisdemo/infrastructure/suggestions/city/city_suggestions_middleware.dart';
import 'package:solarisdemo/infrastructure/suggestions/city/city_suggestions_service.dart';
import 'package:solarisdemo/infrastructure/transactions/transaction_approval_middleware.dart';
import 'package:solarisdemo/infrastructure/transactions/transaction_middleware.dart';
import 'package:solarisdemo/infrastructure/transactions/transaction_service.dart';
import 'package:solarisdemo/infrastructure/transfer/transfer_middleware.dart';
import 'package:solarisdemo/infrastructure/transfer/transfer_service.dart';
import 'package:solarisdemo/redux/app_reducer.dart';
import 'package:solarisdemo/utilities/device_info/device_info.dart';

import 'app_state.dart';

Store<AppState> createStore({
  required AppState initialState,
  required PushNotificationService pushNotificationService,
  required TransactionService transactionService,
  required CreditLineService creditLineService,
  required RepaymentReminderService repaymentReminderService,
  required CardApplicationService cardApplicationService,
  required BillService billService,
  required MoreCreditService moreCreditService,
  required BankCardService bankCardService,
  required CategoriesService categoriesService,
  required PersonService personService,
  required TransferService transferService,
  required ChangeRequestService changeRequestService,
  required DeviceBindingService deviceBindingService,
  required DeviceService deviceService,
  required BiometricsService biometricsService,
  required DeviceInfoService deviceInfoService,
  required AccountSummaryService accountSummaryService,
  required DeviceFingerprintService deviceFingerprintService,
  required AuthService authService,
  required OnboardingService onboardingService,
  required OnboardingSignupService onboardingSignupService,
  required CitySuggestionsService citySuggestionsService,
  required AddressSuggestionsService addressSuggestionsService,
  required OnboardingFinancialDetailsService onboardingFinancialDetailsService,
  required OnboardingPersonalDetailsService onboardingPersonalDetailsService,
  required MobileNumberService mobileNumberService,
  required DocumentsService documentsService,
  required FileSaverService fileSaverService,
  required OnbordingIdentityVerificationService onboardingIdentityVerificationService,
  required OnboardingCardConfigurationService onboardingCardConfigurationService,
}) {
  return Store<AppState>(
    appReducer,
    initialState: initialState,
    middleware: [
      NotificationsMiddleware(pushNotificationService),
      GetTransactionsMiddleware(transactionService),
      GetCreditLineMiddleware(creditLineService),
      RepaymentRemindersMiddleware(repaymentReminderService),
      CardApplicationMiddleware(cardApplicationService),
      GetBillsMiddleware(billService, fileSaverService),
      GetMoreCreditMiddleware(moreCreditService),
      BankCardMiddleware(bankCardService, deviceService, biometricsService, deviceFingerprintService),
      GetCategoriesMiddleware(categoriesService),
      ReferenceAccountMiddleware(personService),
      PersonAccountMiddleware(personService),
      TransferMiddleware(transferService, changeRequestService),
      DeviceBindingMiddleware(deviceBindingService, deviceService, deviceInfoService, deviceFingerprintService),
      TransactionApprovalMiddleware(changeRequestService, deviceService, deviceFingerprintService, biometricsService),
      GetAccountSummaryMiddleware(accountSummaryService),
      AuthMiddleware(authService, deviceService, deviceFingerprintService, personService, biometricsService),
      OnboardingSignupMiddleware(pushNotificationService, onboardingSignupService),
      OnboardingProgressMiddleware(onboardingService),
      OnboardingPersonalDetailsMiddleware(onboardingPersonalDetailsService, mobileNumberService),
      ActionLoggerMiddleware(),
      CitySuggestionsMiddleware(citySuggestionsService),
      AddressSuggestionsMiddleware(addressSuggestionsService),
      OnboardingFinancialDetailsMiddleware(onboardingFinancialDetailsService),
      DocumentsMiddleware(documentsService, fileSaverService),
      OnboardingIdentityVerificationMiddleware(onboardingIdentityVerificationService),
      OnboardingCardConfigurationMiddleware(onboardingCardConfigurationService),
    ],
  );
}
