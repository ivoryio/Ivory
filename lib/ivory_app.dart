import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';
import 'package:solarisdemo/logging/navigation_logging_observer.dart';
import 'package:solarisdemo/models/home/main_navigation_screens.dart';
import 'package:solarisdemo/models/transactions/transaction_model.dart';
import 'package:solarisdemo/navigator.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_action.dart';
import 'package:solarisdemo/screens/account/account_details_screen.dart';
import 'package:solarisdemo/screens/wallet/card_details/card_details_activation_success_screen.dart';
import 'package:solarisdemo/screens/wallet/card_details/card_details_apple_wallet.dart';
import 'package:solarisdemo/screens/wallet/card_details/card_details_choose_pin.dart';
import 'package:solarisdemo/screens/wallet/card_details/card_details_confirm_pin_screen.dart';
import 'package:solarisdemo/screens/wallet/card_details/card_details_info.dart';
import 'package:solarisdemo/screens/wallet/card_details/card_details_screen.dart';
import 'package:solarisdemo/screens/wallet/change_pin/card_change_pin_screen.dart';
import 'package:solarisdemo/screens/home/home_screen.dart';
import 'package:solarisdemo/screens/home/main_navigation_screen.dart';
import 'package:solarisdemo/screens/landing/landing_screen.dart';
import 'package:solarisdemo/screens/login/login_screen.dart';
import 'package:solarisdemo/screens/repayments/bills/bill_detail_screen.dart';
import 'package:solarisdemo/screens/repayments/bills/bills_screen.dart';
import 'package:solarisdemo/screens/repayments/change_repayment_rate.dart';
import 'package:solarisdemo/screens/repayments/more_credit/more_credit_screen.dart';
import 'package:solarisdemo/screens/repayments/more_credit/more_credit_waitlist_screen.dart';
import 'package:solarisdemo/screens/repayments/repayment_reminder.dart';
import 'package:solarisdemo/screens/repayments/repayment_successfully_changed.dart';
import 'package:solarisdemo/screens/repayments/repayments_screen.dart';
import 'package:solarisdemo/screens/settings/settings_device_pairing_screen.dart';
import 'package:solarisdemo/screens/settings/settings_paired_device_details_screen.dart';
import 'package:solarisdemo/screens/settings/settings_screen.dart';
import 'package:solarisdemo/screens/settings/settings_security_screen.dart';
import 'package:solarisdemo/screens/signup/signup_screen.dart';
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
import 'package:solarisdemo/services/auth_service.dart';

import 'screens/transfer/transfer_review_screen.dart';
import 'screens/transfer/transfer_successful_screen.dart';

class IvoryApp extends StatefulWidget {
  static final routeObserver = RouteObserver<PageRoute<dynamic>>();

  final ClientConfigData clientConfig;
  final Store<AppState> store;

  const IvoryApp({super.key, required this.clientConfig, required this.store});

  @override
  State<IvoryApp> createState() => _IvoryAppState();
}

class _IvoryAppState extends State<IvoryApp> {
  // Hack to inform Redux of logged in action
  void _onAuthStateChanged(AuthState state) {
    if (state.user != null) {
      widget.store.dispatch(AuthLoggedInAction(state.user!.cognito));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: widget.store,
      child: BlocProvider(
        create: (context) => AuthCubit(
          authService: AuthService(),
        )..stream.listen(_onAuthStateChanged),
        child: Builder(builder: (context) {
          return MaterialApp(
            title: "Solaris Demo",
            theme: widget.clientConfig.uiSettings.themeData,
            navigatorObservers: [
              IvoryApp.routeObserver,
              NavigationLoggingObserver(),
            ],
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            initialRoute: LandingScreen.routeName,
            routes: {
              // landing
              LandingScreen.routeName: (context) => const LandingScreen(),
              // login
              LoginScreen.routeName: (context) => const LoginScreen(),
              // signup
              SignupScreen.routeName: (context) => const SignupScreen(),
              // home
              HomeScreen.routeName: (context) =>
                  const MainNavigationScreen(initialScreen: MainNavigationScreens.homeScreen),
              // settings
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
                final cardDetailsScreenParams = ModalRoute.of(context)?.settings.arguments as CardDetailsScreenParams?;

                return BankCardDetailsScreen(
                  params: cardDetailsScreenParams!,
                );
              },
              BankCardChangePinScreen.routeName: (context) => const BankCardChangePinScreen(),
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
            },
          );
        }),
      ),
    );
  }
}
