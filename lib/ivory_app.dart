import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/navigator_observers/general_navigation_observer.dart';
import 'package:solarisdemo/navigator_observers/navigation_logging_observer.dart';
import 'package:solarisdemo/models/home/main_navigation_screens.dart';
import 'package:solarisdemo/models/transactions/transaction_model.dart';
import 'package:solarisdemo/navigator.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/screens/account/account_details_screen.dart';
import 'package:solarisdemo/screens/available_balance/available_balance_screen.dart';
import 'package:solarisdemo/screens/login/login_with_biometrics_screen.dart';
import 'package:solarisdemo/screens/login/login_with_tan_screen.dart';
import 'package:solarisdemo/screens/onboarding/financial_details/onboarding_monthly_income_screen.dart';
import 'package:solarisdemo/screens/onboarding/financial_details/onboarding_occupational_status_screen.dart';
import 'package:solarisdemo/screens/onboarding/financial_details/onboarding_public_status_screen.dart';
import 'package:solarisdemo/screens/onboarding/financial_details/onboarding_remember_screen.dart';
import 'package:solarisdemo/screens/onboarding/financial_details/onboarding_taxId_screen.dart';
import 'package:solarisdemo/screens/onboarding/identity_verification/onboarding_identity_verification_method_screen.dart';
import 'package:solarisdemo/screens/onboarding/identity_verification/onboarding_video_identification_not_available_screen.dart';
import 'package:solarisdemo/screens/onboarding/personal_details/onboarding_address_of_residence_error_screen.dart';
import 'package:solarisdemo/screens/onboarding/personal_details/onboarding_address_of_residence_screen.dart';
import 'package:solarisdemo/screens/onboarding/personal_details/onboarding_mobile_number_screen.dart';
import 'package:solarisdemo/screens/onboarding/personal_details/onboarding_date_and_place_of_birth_screen.dart';
import 'package:solarisdemo/screens/onboarding/personal_details/onboarding_nationality_not_supported_screen.dart';
import 'package:solarisdemo/screens/onboarding/personal_details/onboarding_verify_mobile_number_screen.dart';
import 'package:solarisdemo/screens/onboarding/signup/onboarding_email_screen.dart';
import 'package:solarisdemo/screens/onboarding/signup/onboarding_error_email_screen.dart';
import 'package:solarisdemo/screens/onboarding/signup/onboarding_general_error_screen.dart';
import 'package:solarisdemo/screens/onboarding/signup/onboarding_password_screen.dart';
import 'package:solarisdemo/screens/onboarding/signup/onboarding_basic_info_screen.dart';
import 'package:solarisdemo/screens/onboarding/signup/onboarding_term_conditions_screen.dart';
import 'package:solarisdemo/screens/onboarding/start/onboarding_german_residency_error_screen.dart';
import 'package:solarisdemo/screens/onboarding/start/onboarding_german_residency_screen.dart';
import 'package:solarisdemo/screens/onboarding/start/onboarding_usa_tax_payer_error_screen.dart';
import 'package:solarisdemo/screens/settings/app_settings/biometric_enabled_screen.dart';
import 'package:solarisdemo/screens/settings/app_settings/biometric_needed_screen.dart';
import 'package:solarisdemo/screens/onboarding/onboarding_stepper_screen.dart';
import 'package:solarisdemo/screens/wallet/card_activation/card_activation_apple_wallet.dart';
import 'package:solarisdemo/screens/wallet/card_activation/card_activation_choose_pin.dart';
import 'package:solarisdemo/screens/wallet/card_activation/card_activation_confirm_pin_screen.dart';
import 'package:solarisdemo/screens/wallet/card_activation/card_activation_info.dart';
import 'package:solarisdemo/screens/wallet/card_activation/card_activation_success_screen.dart';
import 'package:solarisdemo/screens/wallet/card_details/card_details_screen.dart';
import 'package:solarisdemo/screens/wallet/change_pin/card_change_pin_choose_screen.dart';
import 'package:solarisdemo/screens/home/home_screen.dart';
import 'package:solarisdemo/screens/home/main_navigation_screen.dart';
import 'package:solarisdemo/screens/welcome/welcome_screen.dart';
import 'package:solarisdemo/screens/login/login_screen.dart';
import 'package:solarisdemo/screens/repayments/bills/bill_detail_screen.dart';
import 'package:solarisdemo/screens/repayments/bills/bills_screen.dart';
import 'package:solarisdemo/screens/repayments/change_repayment_rate.dart';
import 'package:solarisdemo/screens/repayments/more_credit/more_credit_screen.dart';
import 'package:solarisdemo/screens/repayments/more_credit/more_credit_waitlist_screen.dart';
import 'package:solarisdemo/screens/repayments/repayment_reminder.dart';
import 'package:solarisdemo/screens/repayments/repayment_successfully_changed.dart';
import 'package:solarisdemo/screens/repayments/repayments_screen.dart';
import 'package:solarisdemo/screens/settings/device_pairing/settings_device_pairing_inital_screen.dart';
import 'package:solarisdemo/screens/settings/device_pairing/settings_device_pairing_screen.dart';
import 'package:solarisdemo/screens/settings/device_pairing/settings_device_pairing_success_screen.dart';
import 'package:solarisdemo/screens/settings/device_pairing/settings_device_pairing_verify_pairing_screen.dart';
import 'package:solarisdemo/screens/settings/device_pairing/settings_paired_device_details_screen.dart';
import 'package:solarisdemo/screens/settings/settings_screen.dart';
import 'package:solarisdemo/screens/settings/settings_security_screen.dart';
import 'package:solarisdemo/screens/transactions/transaction_approval_failed_screen.dart';
import 'package:solarisdemo/screens/transactions/transaction_approval_pending_screen.dart';
import 'package:solarisdemo/screens/transactions/transaction_approval_rejected_screen.dart';
import 'package:solarisdemo/screens/transactions/transaction_approval_success_screen.dart';
import 'package:solarisdemo/screens/transactions/transaction_detail_screen.dart';
import 'package:solarisdemo/screens/transactions/transactions_filtering_screen.dart';
import 'package:solarisdemo/screens/transactions/transactions_screen.dart';
import 'package:solarisdemo/screens/transfer/transfer_failed_screen.dart';
import 'package:solarisdemo/screens/transfer/transfer_screen.dart';
import 'package:solarisdemo/screens/transfer/transfer_sign_screen.dart';
import 'package:solarisdemo/screens/wallet/cards_screen.dart';
import 'package:solarisdemo/screens/wallet/change_pin/card_change_pin_confirm_screen.dart';
import 'package:solarisdemo/screens/wallet/change_pin/card_change_pin_success_screen.dart';
import 'package:solarisdemo/utilities/helpers/force_reload_helper.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/screens/onboarding/start/onboarding_start_screen.dart';
import 'package:solarisdemo/screens/onboarding/start/onboarding_usa_tax_payer_screen.dart';
import 'package:solarisdemo/screens/transfer/transfer_review_screen.dart';
import 'package:solarisdemo/screens/transfer/transfer_successful_screen.dart';
import 'package:solarisdemo/screens/onboarding/signup/onboarding_allow_notifications_screen.dart';

class IvoryApp extends StatefulWidget {
  static final routeObserver = RouteObserver<PageRoute<dynamic>>();
  static final generalRouteObserver = NavigationGeneralObserver();
  static final loggingObserver = NavigationLoggingObserver();

  final ClientConfigData clientConfig;
  final Store<AppState> store;

  const IvoryApp({super.key, required this.clientConfig, required this.store});

  @override
  State<IvoryApp> createState() => _IvoryAppState();
}

class _IvoryAppState extends State<IvoryApp> with WidgetsBindingObserver {
  User? user;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.hidden) {
      final store = widget.store;

      forceReloadAppStates(store);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: widget.store,
      child: Builder(builder: (context) {
        return MaterialApp(
          title: "Ivory Demo",
          theme: widget.clientConfig.uiSettings.themeData,
          navigatorObservers: [
            IvoryApp.routeObserver,
            IvoryApp.loggingObserver,
            IvoryApp.generalRouteObserver,
          ],
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          initialRoute: WelcomeScreen.routeName,
          routes: {
            // landing
            WelcomeScreen.routeName: (context) => const WelcomeScreen(),
            // login
            LoginScreen.routeName: (context) => const LoginScreen(),
            LoginWithTanScreen.routeName: (context) => const LoginWithTanScreen(),
            LoginWithBiometricsScreen.routeName: (context) => const LoginWithBiometricsScreen(),
            // home
            HomeScreen.routeName: (context) =>
                const MainNavigationScreen(initialScreen: MainNavigationScreens.homeScreen),
            AvailableBalanceScreen.routeName: (context) => const AvailableBalanceScreen(),
            // settings - security
            SettingsScreen.routeName: (context) =>
                const MainNavigationScreen(initialScreen: MainNavigationScreens.settingsScreen),
            SettingsSecurityScreen.routeName: (context) => const SettingsSecurityScreen(),
            SettingsDevicePairingScreen.routeName: (context) => const SettingsDevicePairingScreen(),
            SettingsPairedDeviceDetailsScreen.routeName: (context) {
              final pairedDeviceDetailsScreenParams =
                  ModalRoute.of(context)?.settings.arguments as SettingsPairedDeviceDetailsScreenParams?;

              return SettingsPairedDeviceDetailsScreen(
                params: pairedDeviceDetailsScreenParams!,
              );
            },
            SettingsDevicePairingInitialScreen.routeName: (context) => const SettingsDevicePairingInitialScreen(),
            SettingsDevicePairingVerifyPairingScreen.routeName: (context) =>
                const SettingsDevicePairingVerifyPairingScreen(),
            SettingsDevicePairingSuccessScreen.routeName: (context) => const SettingsDevicePairingSuccessScreen(),

            //settings - app settings
            AppSettingsBiometricNeededScreen.routeName: (context) => const AppSettingsBiometricNeededScreen(),
            AppSettingsBiometricEnabledScreen.routeName: (context) => const AppSettingsBiometricEnabledScreen(),

            //transactions
            TransactionsScreen.routeName: (context) {
              final transactionListFilter = ModalRoute.of(context)?.settings.arguments as TransactionListFilter?;

              return MainNavigationScreen(
                  initialScreen: MainNavigationScreens.transactionsScreen, screenParams: transactionListFilter);
            },
            TransactionsFilteringScreen.routeName: (context) {
              final transactionListFilter = ModalRoute.of(context)?.settings.arguments as TransactionListFilter?;

              return TransactionsFilteringScreen(
                transactionListFilter: transactionListFilter,
              );
            },
            TransactionDetailScreen.routeName: (context) => const TransactionDetailScreen(),
            TransactionApprovalPendingScreen.routeName: (context) => const TransactionApprovalPendingScreen(),
            TransactionApprovalSuccessScreen.routeName: (context) => const TransactionApprovalSuccessScreen(),
            TransactionApprovalRejectedScreen.routeName: (context) => const TransactionApprovalRejectedScreen(),
            TransactionApprovalFailedScreen.routeName: (context) => const TransactionApprovalFailedScreen(),
            // wallet
            BankCardsScreen.routeName: (context) =>
                const MainNavigationScreen(initialScreen: MainNavigationScreens.cardsScreen),
            BankCardDetailsChoosePinScreen.routeName: (context) => const BankCardDetailsChoosePinScreen(),
            BankCardDetailsConfirmPinScreen.routeName: (context) => const BankCardDetailsConfirmPinScreen(),
            BankCardDetailsAppleWalletScreen.routeName: (context) => const BankCardDetailsAppleWalletScreen(),
            BankCardDetailsActivationSuccessScreen.routeName: (context) =>
                const BankCardDetailsActivationSuccessScreen(),
            BankCardDetailsInfoScreen.routeName: (context) => const BankCardDetailsInfoScreen(),
            BankCardDetailsScreen.routeName: (context) {
              final cardDetailsScreenParams = ModalRoute.of(context)?.settings.arguments as CardScreenParams?;

              return BankCardDetailsScreen(
                params: cardDetailsScreenParams!,
              );
            },
            BankCardChangePinChooseScreen.routeName: (context) => const BankCardChangePinChooseScreen(),
            BankCardConfirmPinConfirmScreen.routeName: (context) => const BankCardConfirmPinConfirmScreen(),
            BankCardChangePinSuccessScreen.routeName: (context) => const BankCardChangePinSuccessScreen(),

            // repayments
            RepaymentsScreen.routeName: (context) => const RepaymentsScreen(),
            ChangeRepaymentRateScreen.routeName: (context) => const ChangeRepaymentRateScreen(),
            RepaymentSuccessfullyChangedScreen.routeName: (context) {
              final params = ModalRoute.of(context)?.settings.arguments as RepaymentSuccessfullyScreenParams;

              return RepaymentSuccessfullyChangedScreen(params: params);
            },
            RepaymentReminderScreen.routeName: (context) => const RepaymentReminderScreen(),

            MoreCreditScreen.routeName: (context) => const MoreCreditScreen(),
            MoreCreditWaitlistScreen.routeName: (context) => const MoreCreditWaitlistScreen(),

            BillsScreen.routeName: (context) => const BillsScreen(),
            BillDetailScreen.routeName: (context) => const BillDetailScreen(),
            // transfer
            TransferScreen.routeName: (context) => const TransferScreen(),
            TransferReviewScreen.routeName: (context) {
              return TransferReviewScreen(
                params: ModalRoute.of(context)?.settings.arguments as TransferReviewScreenParams,
              );
            },
            TransferSignScreen.routeName: (context) => const TransferSignScreen(),
            TransferSuccessfulScreen.routeName: (context) => const TransferSuccessfulScreen(),
            TransferFailedScreen.routeName: (context) => const TransferFailedScreen(),
            // account
            AccountDetailsScreen.routeName: (context) => const AccountDetailsScreen(),
            // onboarding
            OnboardingStepperScreen.routeName: (context) => const OnboardingStepperScreen(),
            OnboardingStartScreen.routeName: (context) => const OnboardingStartScreen(),
            OnboardingGermanResidencyScreen.routeName: (context) => const OnboardingGermanResidencyScreen(),
            OnboardingGermanResidencyErrorScreen.routeName: (context) => const OnboardingGermanResidencyErrorScreen(),
            OnboardingUsaTaxPayerScreen.routeName: (context) => const OnboardingUsaTaxPayerScreen(),
            OnboardingUsaTaxPayerErrorScreen.routeName: (context) => const OnboardingUsaTaxPayerErrorScreen(),
            // onboarding/sign_up
            OnboardingBasicInfoScreen.routeName: (context) => const OnboardingBasicInfoScreen(),
            OnboardingEmailScreen.routeName: (context) => const OnboardingEmailScreen(),
            OnboardingPasswordScreen.routeName: (context) => const OnboardingPasswordScreen(),
            OnboardingAllowNotificationsScreen.routeName: (context) => const OnboardingAllowNotificationsScreen(),
            OnboardingTermConditionsScreen.routeName: (context) => const OnboardingTermConditionsScreen(),
            OnboardingErrorEmailScreen.routeName: (context) => const OnboardingErrorEmailScreen(),
            OnboardingGeneralErrorScreen.routeName: (context) => const OnboardingGeneralErrorScreen(),
            // onboarding/personal_details
            OnboardingDateAndPlaceOfBirthScreen.routeName: (context) => const OnboardingDateAndPlaceOfBirthScreen(),
            OnboardingNationalityNotSupportedScreen.routeName: (context) =>
                const OnboardingNationalityNotSupportedScreen(),
            OnboardingAddressOfResidenceScreen.routeName: (context) => const OnboardingAddressOfResidenceScreen(),
            OnboardingAddressOfResidenceErrorScreen.routeName: (context) =>
                const OnboardingAddressOfResidenceErrorScreen(),
            OnboardingMobileNumberScreen.routeName: (context) => const OnboardingMobileNumberScreen(),
            OnboardingVerifyMobileNumberScreen.routeName: (context) => const OnboardingVerifyMobileNumberScreen(),
            // onboarding/financial_details
            OnboardingRememberScreen.routeName: (context) => const OnboardingRememberScreen(),
            OnboardingTaxIdScreen.routeName: (context) => const OnboardingTaxIdScreen(),
            OnboardingPublicStatusScreen.routeName: (context) => const OnboardingPublicStatusScreen(),
            OnboardingOccupationalStatusScreen.routeName: (context) => const OnboardingOccupationalStatusScreen(),
            OnboardingMonthlyIncomeScreen.routeName: (context) => const OnboardingMonthlyIncomeScreen(),
            // onboarding/identity_verification
            OnboardingIdentityVerificationMethodScreen.routeName: (context) =>
                const OnboardingIdentityVerificationMethodScreen(),
            OnboardingVideoIdentificationNotAvailableScreen.routeName: (context) =>
                const OnboardingVideoIdentificationNotAvailableScreen(),
          },
        );
      }),
    );
  }
}
