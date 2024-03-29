import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
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
import 'package:solarisdemo/infrastructure/documents/file_saver_service.dart';
import 'package:solarisdemo/infrastructure/mobile_number/mobile_number_service.dart';
import 'package:solarisdemo/infrastructure/notifications/push_notification_service.dart';
import 'package:solarisdemo/infrastructure/notifications/push_notification_service_provider.dart';
import 'package:solarisdemo/infrastructure/notifications/push_notification_storage_service.dart';
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
import 'package:solarisdemo/ivory_app.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/store_factory.dart';
import 'package:solarisdemo/utilities/device_info/device_info.dart';

import '../config.dart';
import 'firebase_options.dart';

Future<void> main() async {
  await dotenv.load();
  ClientConfigData clientConfig = ClientConfig.getClientConfig();

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  PushNotificationServiceProvider.init(FirebasePushNotificationService(
    storageService: PushNotificationSharedPreferencesStorageService(),
  ));

  final pushNotificationService = PushNotificationServiceProvider.instance.service;

  final store = _buildStore(pushNotificationService);

  runApp(IvoryApp(
    clientConfig: clientConfig,
    store: store,
  ));
}

Store<AppState> _buildStore(PushNotificationService pushNotificationService) {
  final store = createStore(
    initialState: AppState.initialState(),
    pushNotificationService: pushNotificationService,
    transactionService: TransactionService(),
    creditLineService: CreditLineService(),
    repaymentReminderService: RepaymentReminderService(),
    cardApplicationService: CardApplicationService(),
    billService: BillService(),
    moreCreditService: MoreCreditService(),
    bankCardService: BankCardService(),
    categoriesService: CategoriesService(),
    personService: PersonService(),
    transferService: TransferService(),
    changeRequestService: ChangeRequestService(),
    deviceBindingService: DeviceBindingService(),
    deviceService: DeviceService(),
    biometricsService: BiometricsService(),
    deviceInfoService: DeviceInfoService(),
    accountSummaryService: AccountSummaryService(),
    deviceFingerprintService: DeviceFingerprintService(),
    authService: AuthService(),
    onboardingService: OnboardingService(),
    onboardingSignupService: OnboardingSignupService(),
    citySuggestionsService: CitySuggestionsService(),
    addressSuggestionsService: AddressSuggestionsService(),
    onboardingFinancialDetailsService: OnboardingFinancialDetailsService(),
    onboardingPersonalDetailsService: OnboardingPersonalDetailsService(),
    mobileNumberService: MobileNumberService(),
    documentsService: DocumentsService(),
    fileSaverService: FileSaverService(),
    onboardingIdentityVerificationService: OnbordingIdentityVerificationService(),
    onboardingCardConfigurationService: OnboardingCardConfigurationService(),
  );

  return store;
}
