import 'dart:typed_data';

import 'package:local_auth/local_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/auth/auth_service.dart';
import 'package:solarisdemo/infrastructure/bank_card/bank_card_service.dart';
import 'package:solarisdemo/infrastructure/categories/categories_service.dart';
import 'package:solarisdemo/infrastructure/change_request/change_request_service.dart';
import 'package:solarisdemo/infrastructure/credit_line/credit_line_service.dart';
import 'package:solarisdemo/infrastructure/device/biometrics_service.dart';
import 'package:solarisdemo/infrastructure/device/device_binding_service.dart';
import 'package:solarisdemo/infrastructure/device/device_fingerprint_service.dart';
import 'package:solarisdemo/infrastructure/device/device_service.dart';
import 'package:solarisdemo/infrastructure/documents/documents_service.dart';
import 'package:solarisdemo/infrastructure/file_saver_service.dart';
import 'package:solarisdemo/infrastructure/mobile_number/mobile_number_service.dart';
import 'package:solarisdemo/infrastructure/notifications/push_notification_service.dart';
import 'package:solarisdemo/infrastructure/onboarding/card_configuration/onboarding_card_configuration_service.dart';
import 'package:solarisdemo/infrastructure/onboarding/financial_details/onboarding_financial_details_service.dart';
import 'package:solarisdemo/infrastructure/onboarding/identity_verification/onboarding_identity_verification_service.dart';
import 'package:solarisdemo/infrastructure/onboarding/onboarding_service.dart';
import 'package:solarisdemo/infrastructure/onboarding/personal_details/onboarding_personal_details_service.dart';
import 'package:solarisdemo/infrastructure/onboarding/signup/onboarding_signup_service.dart';
import 'package:solarisdemo/infrastructure/person/account_summary/account_summary_service.dart';
import 'package:solarisdemo/infrastructure/person/person_service.dart';
import 'package:solarisdemo/infrastructure/repayments/bills/bill_service.dart';
import 'package:solarisdemo/infrastructure/repayments/change_repayment/change_repayment_service.dart';
import 'package:solarisdemo/infrastructure/repayments/more_credit/more_credit_service.dart';
import 'package:solarisdemo/infrastructure/repayments/reminder/repayment_reminder_service.dart';
import 'package:solarisdemo/infrastructure/suggestions/address/address_suggestions_service.dart';
import 'package:solarisdemo/infrastructure/suggestions/city/city_suggestions_service.dart';
import 'package:solarisdemo/infrastructure/transactions/transaction_service.dart';
import 'package:solarisdemo/infrastructure/transfer/transfer_service.dart';
import 'package:solarisdemo/models/bank_card.dart';
import 'package:solarisdemo/models/device.dart';
import 'package:solarisdemo/models/device_activity.dart';
import 'package:solarisdemo/models/onboarding/onboarding_financial_details_attributes.dart';
import 'package:solarisdemo/models/documents/document.dart';
import 'package:solarisdemo/models/onboarding/onboarding_signup_attributes.dart';
import 'package:solarisdemo/models/suggestions/address_suggestion.dart';
import 'package:solarisdemo/models/transactions/transaction_model.dart';
import 'package:solarisdemo/models/transfer/reference_account_transfer.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/store_factory.dart';
import 'package:solarisdemo/utilities/crypto/crypto_key_generator.dart';
import 'package:solarisdemo/utilities/device_info/device_info.dart';

Store<AppState> createTestStore({
  required AppState initialState,
  PushNotificationService? pushNotificationService,
  TransactionService? transactionService,
  CreditLineService? creditLineService,
  RepaymentReminderService? repaymentReminderService,
  CardApplicationService? cardApplicationService,
  BillService? billService,
  MoreCreditService? moreCreditService,
  BankCardService? bankCardService,
  CategoriesService? categoriesService,
  PersonService? personService,
  TransferService? transferService,
  ChangeRequestService? changeRequestService,
  DeviceBindingService? deviceBindingService,
  DeviceService? deviceService,
  BiometricsService? biometricsService,
  DeviceInfoService? deviceInfoService,
  AccountSummaryService? accountSummaryService,
  DeviceFingerprintService? deviceFingerprintService,
  AuthService? authService,
  OnboardingService? onboardingService,
  OnboardingSignupService? onboardingSignupService,
  CitySuggestionsService? citySuggestionsService,
  AddressSuggestionsService? addressSuggestionsService,
  OnboardingFinancialDetailsService? onboardingFinancialDetailsService,
  OnboardingPersonalDetailsService? onboardingPersonalDetailsService,
  MobileNumberService? mobileNumberService,
  DocumentsService? documentsService,
  FileSaverService? fileSaverService,
  OnbordingIdentityVerificationService? onboardingIdentityVerificationService,
  OnboardingCardConfigurationService? onboardingCardConfigurationService,
}) {
  return createStore(
    initialState: initialState,
    pushNotificationService: pushNotificationService ?? NotImplementedPushNotificationService(),
    transactionService: transactionService ?? NotImplementedTransactionService(),
    creditLineService: creditLineService ?? NotImplementedCreditLineService(),
    repaymentReminderService: repaymentReminderService ?? NotImplementedRepaymentReminderService(),
    cardApplicationService: cardApplicationService ?? NotImplementedCardApplicationService(),
    billService: billService ?? NotImplementedBillService(),
    moreCreditService: moreCreditService ?? NotImplementedMoreCreditService(),
    bankCardService: bankCardService ?? NotImplementedBankCardService(),
    categoriesService: categoriesService ?? NotImplementedCategoriesService(),
    personService: personService ?? NotImplementedPersonService(),
    transferService: transferService ?? NotImplementedTransferService(),
    changeRequestService: changeRequestService ?? NotImplementedChangeRequestService(),
    deviceBindingService: deviceBindingService ?? NotImplementedDeviceBindingService(),
    deviceService: deviceService ?? NotImplementedDeviceService(),
    biometricsService: biometricsService ?? NotImplementedBiometricsService(),
    deviceInfoService: deviceInfoService ?? NotImplementedDeviceInfoService(),
    accountSummaryService: accountSummaryService ?? NotImplementedAccountSummaryService(),
    deviceFingerprintService: deviceFingerprintService ?? NotImplementedDeviceFingerprintService(),
    authService: authService ?? NotImplementedAuthService(),
    onboardingService: onboardingService ?? NotImplementedOnboardingService(),
    onboardingSignupService: onboardingSignupService ?? NotImplementedOnboardingSignupService(),
    citySuggestionsService: citySuggestionsService ?? NotImplementedCitySuggestionsService(),
    addressSuggestionsService: addressSuggestionsService ?? NotImplementedAddressSuggestionsService(),
    onboardingFinancialDetailsService:
        onboardingFinancialDetailsService ?? NotImplementedOnboardingFinancialDetailsService(),
    onboardingPersonalDetailsService:
        onboardingPersonalDetailsService ?? NotImplementedOnboardingPersonalDetailsService(),
    mobileNumberService: mobileNumberService ?? NotImplementedMobileNumberService(),
    documentsService: documentsService ?? NotImplementedDocumentsService(),
    fileSaverService: fileSaverService ?? NotImplementedFileSaverService(),
    onboardingIdentityVerificationService:
        onboardingIdentityVerificationService ?? NotImplementedOnbordingIdentityVerificationService(),
    onboardingCardConfigurationService:
        onboardingCardConfigurationService ?? NotImplementedOnboardingCardConfigurationService(),
  );
}

class NotImplementedDeviceInfoService extends DeviceInfoService {
  @override
  Future<String> getDeviceName() {
    throw UnimplementedError();
  }
}

class NotImplementedPushNotificationService extends PushNotificationService {
  @override
  Future<void> init(Store<AppState> store, {User? user}) {
    throw UnimplementedError();
  }

  @override
  Future<bool> hasPermission() {
    throw UnimplementedError();
  }

  @override
  Future<void> handleSavedNotification() {
    throw UnimplementedError();
  }

  @override
  Future<void> clearNotification() {
    throw UnimplementedError();
  }

  @override
  Future<String?> getToken() {
    throw UnimplementedError();
  }

  @override
  void handleTokenRefresh({User? user}) {
    throw UnimplementedError();
  }
}

class NotImplementedTransactionService extends TransactionService {
  @override
  Future<TransactionsServiceResponse> getTransactions({TransactionListFilter? filter, User? user}) {
    throw UnimplementedError();
  }
}

class NotImplementedCreditLineService extends CreditLineService {
  @override
  Future<CreditLineServiceResponse> getCreditLine({User? user}) {
    throw UnimplementedError();
  }
}

class NotImplementedRepaymentReminderService extends RepaymentReminderService {
  @override
  Future<RepaymentReminderServiceResponse> getRepaymentReminders({User? user}) {
    throw UnimplementedError();
  }
}

class NotImplementedCardApplicationService extends CardApplicationService {
  @override
  Future<ChangeRepaymentResponse> getCardApplication({User? user}) {
    throw UnimplementedError();
  }

  @override
  Future<ChangeRepaymentResponse> updateChangeRepayment(
      {User? user, required double fixedRate, required int percentageRate, required String id}) {
    throw UnimplementedError();
  }
}

class NotImplementedBillService extends BillService {
  @override
  Future<BillServiceResponse> getBills({User? user}) {
    throw UnimplementedError();
  }

  @override
  Future<BillServiceResponse> getBillById({required String id, User? user}) {
    throw UnimplementedError();
  }
}

class NotImplementedMoreCreditService extends MoreCreditService {
  @override
  Future<MoreCreditServiceResponse> changeWaitlistStatus({
    User? user,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<MoreCreditServiceResponse> getWaitlistStatus({
    User? user,
  }) {
    throw UnimplementedError();
  }
}

class NotImplementedBankCardService extends BankCardService {
  @override
  Future<BankCardServiceResponse> getBankCardById({User? user, String? cardId}) {
    throw UnimplementedError();
  }

  @override
  Future<BankCardServiceResponse> activateBankCard({User? user, String? cardId}) {
    throw UnimplementedError();
  }

  @override
  Future<BankCardServiceResponse> createBankCard({
    required User? user,
    required CreateBankCardReqBody reqBody,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<BankCardServiceResponse> freezeCard({
    required String cardId,
    required User? user,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<BankCardServiceResponse> unfreezeCard({
    required String cardId,
    required User? user,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<BankCardServiceResponse> getLatestPinKey({
    required String cardId,
    required User? user,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<BankCardServiceResponse> changePin({
    required String cardId,
    required User? user,
    required ChangePinRequestBody reqBody,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<BankCardServiceResponse> getBankCards({User? user}) {
    throw UnimplementedError();
  }
}

class NotImplementedCategoriesService extends CategoriesService {
  @override
  Future<CategoriesServiceResponse> getCategories({User? user}) {
    throw UnimplementedError();
  }
}

class NotImplementedPersonService extends PersonService {
  @override
  Future<PersonServiceResponse> getReferenceAccount({User? user}) {
    throw UnimplementedError();
  }

  @override
  Future<PersonServiceResponse> getPersonAccount({User? user}) {
    throw UnimplementedError();
  }
}

class NotImplementedTransferService extends TransferService {
  @override
  Future<TransferServiceResponse> createPayoutTransfer({
    User? user,
    required ReferenceAccountTransfer transfer,
  }) {
    throw UnimplementedError();
  }
}

class NotImplementedChangeRequestService extends ChangeRequestService {
  @override
  Future<ChangeRequestServiceResponse> confirmTransferChangeRequest({
    User? user,
    required String changeRequestId,
    required String tan,
  }) {
    throw UnimplementedError();
  }
}

class NotImplementedDeviceBindingService extends DeviceBindingService {
  @override
  Future<DeviceBindingServiceResponse> createDeviceBinding({
    required User user,
    required CreateDeviceBindingRequest reqBody,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<DeviceBindingServiceResponse> verifyDeviceBindingSignature(
      {required User user, required String deviceId, required String deviceFingerPrint, required String signature}) {
    throw UnimplementedError();
  }

  @override
  Future<DeviceBindingServiceResponse> createRestrictedKey({
    required User user,
    required CreateRestrictedKeyRequest reqBody,
  }) {
    throw UnimplementedError();
  }
}

class NotImplementedDeviceService extends DeviceService {
  @override
  Future<String?> getConsentId() async {
    throw UnimplementedError();
  }

  @override
  Future<String?> getDeviceId() async {
    throw UnimplementedError();
  }

  @override
  Future<DeviceKeyPairs?> getDeviceKeyPairs({bool restricted = false}) async {
    throw UnimplementedError();
  }

  @override
  Future<void> saveKeyPairIntoCache({
    required DeviceKeyPairs keyPair,
    bool restricted = false,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> saveDeviceIdIntoCache(String deviceId) async {
    throw UnimplementedError();
  }

  @override
  DeviceKeyPairs? generateECKey() {
    throw UnimplementedError();
  }

  @override
  RSAKeyPair? generateRSAKey() {
    throw UnimplementedError();
  }

  @override
  String? generateSignature({required String privateKey, required String stringToSign}) {
    throw UnimplementedError();
  }
}

class MockLocalAutentication extends Mock implements LocalAuthentication {}

class NotImplementedBiometricsService extends BiometricsService {
  NotImplementedBiometricsService() : super();
}

class NotImplementedAccountSummaryService extends AccountSummaryService {
  @override
  Future<AccountSummaryServiceResponse> getPersonAccountSummary({User? user}) {
    throw UnimplementedError();
  }
}

class NotImplementedDeviceFingerprintService extends DeviceFingerprintService {
  @override
  Future<DeviceFingerprintServiceResponse> createDeviceConsent({
    User? user,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<DeviceFingerprintServiceResponse> createDeviceActivity({
    User? user,
    required DeviceActivityType activityType,
    required String deviceFingerprint,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<String?> getDeviceFingerprint(String? consentId) async {
    throw UnimplementedError();
  }
}

class NotImplementedAuthService extends AuthService {
  @override
  Future<AuthServiceResponse> login(String userName, String password) {
    throw UnimplementedError();
  }
}

class NotImplementedOnboardingService extends OnboardingService {
  @override
  Future<OnboardingServiceResponse> getOnboardingProgress({required User user}) {
    throw UnimplementedError();
  }
}

class NotImplementedOnboardingSignupService extends OnboardingSignupService {
  @override
  Future<OnboardingSignupServiceResponse> createPerson({
    required OnboardingSignupAttributes signupAttributes,
    required String deviceToken,
    required String tsAndCsSignedAt,
  }) async {
    throw UnimplementedError();
  }
}

class NotImplementedOnboardingFinancialDetailsService extends OnboardingFinancialDetailsService {
  @override
  Future<FinancialDetailsServiceResponse> createTaxIdentification({
    required User user,
    required String taxId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<FinancialDetailsServiceResponse> createCreditCardApplication({
    required User user,
    required OnboardingMaritalStatus maritalStatus,
    required OnboardingLivingSituation livingSituation,
    required int numberOfDependents,
    required OnboardingOccupationalStatus occupationalStatus,
    required String dateOfEmployment,
    required num monthlyIncome,
    required num monthlyExpense,
    required num totalCurrentDebt,
    required num totalCreditLimit,
  }) {
    throw UnimplementedError();
  }
}

class NotImplementedCitySuggestionsService extends CitySuggestionsService {
  @override
  Future<CitySuggestionsServiceResponse> fetchCities({required String countryCode, String? searchTerm}) {
    throw UnimplementedError();
  }
}

class NotImplementedAddressSuggestionsService extends AddressSuggestionsService {
  @override
  Future<AddressSuggestionsServiceResponse> getAddressSuggestions({required User user, required String query}) {
    throw UnimplementedError();
  }
}

class NotImplementedOnboardingPersonalDetailsService extends OnboardingPersonalDetailsService {
  @override
  Future<OnboardingPersonalDetailsServiceResponse> createPerson({
    required User user,
    required AddressSuggestion address,
    required String birthDate,
    required String birthCity,
    required String birthCountry,
    required String nationality,
    required String addressLine,
  }) async {
    throw UnimplementedError();
  }
}

class NotImplementedMobileNumberService extends MobileNumberService {
  @override
  Future<MobileNumberServiceResponse> createMobileNumber({
    required User user,
    required String mobileNumber,
    String deviceData = '',
  }) async {
    throw UnimplementedError();
  }
}

class NotImplementedDocumentsService extends DocumentsService {
  @override
  Future<DocumentsServiceResponse> getPostboxDocuments({required User user}) async {
    throw UnimplementedError();
  }

  @override
  Future<DocumentsServiceResponse> downloadDocument({
    required User user,
    required Document document,
    required DocumentDownloadLocation downloadLocation,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<DocumentsServiceResponse> confirmPostboxDocuments({
    required User user,
    required List<Document> documents,
  }) async {
    throw UnimplementedError();
  }
}

class NotImplementedFileSaverService extends FileSaverService {
  @override
  Future<void> saveFile({required String name, String? ext, required Uint8List bytes, String? mimeType}) async {
    throw UnimplementedError();
  }
}

class NotImplementedOnbordingIdentityVerificationService extends OnbordingIdentityVerificationService {
  @override
  Future<IdentityVerificationServiceResponse> createIdentification({
    required User user,
    required String accountName,
    required String iban,
    required String termsAndCondsSignedAt,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<IdentityVerificationServiceResponse> signWithTan({required String tan}) async {
    throw UnimplementedError();
  }

  @override
  Future<IdentityVerificationServiceResponse> getSignupIdentificationInfo({
    required User user,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<IdentityVerificationServiceResponse> authorizeIdentification({required User user}) async {
    throw UnimplementedError();
  }
}

class NotImplementedOnboardingCardConfigurationService extends OnboardingCardConfigurationService {
  @override
  Future<OnboardingCardConfigurationResponse> getCardholderName({required User user}) {
    throw UnimplementedError();
  }
}
