import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/logging/navigation_logging_observer.dart';
import 'package:solarisdemo/models/home/main_navigation_screens.dart';
import 'package:solarisdemo/navigator.dart';
import 'package:solarisdemo/screens/account/account_details_screen.dart';
import 'package:solarisdemo/screens/home/home_screen.dart';
import 'package:solarisdemo/screens/home/main_navigation_screen.dart';
import 'package:solarisdemo/screens/landing/landing_screen.dart';
import 'package:solarisdemo/screens/login/login_screen.dart';
import 'package:solarisdemo/screens/profile/profile_screen.dart';
import 'package:solarisdemo/screens/signup/signup_screen.dart';
import 'package:solarisdemo/screens/transactions/transactions_screen.dart';
import 'package:solarisdemo/screens/transfer/transfer_screen.dart';
import 'package:solarisdemo/screens/wallet/card_details_screen.dart';
import 'package:solarisdemo/screens/wallet/wallet_screen.dart';
import 'package:solarisdemo/services/auth_service.dart';

import '../config.dart';
import '../cubits/auth_cubit/auth_cubit.dart';
import 'screens/repayments/repayments_screen.dart';
import 'screens/splitpay/splitpay_screen.dart';
import 'screens/transactions/transactions_filtering_screen.dart';
import 'services/transaction_service.dart';

class IvoryApp extends StatefulWidget {
  static final routeObserver = RouteObserver<PageRoute<dynamic>>();

  final ClientConfigData clientConfig;

  const IvoryApp({
    super.key,
    required this.clientConfig,
  });

  @override
  State<IvoryApp> createState() => _IvoryAppState();
}

class _IvoryAppState extends State<IvoryApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(
        authService: AuthService(),
      ),
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
            HomeScreen.routeName: (context) => const MainNavigationScreen(
                initialScreen: MainNavigationScreens.homeScreen),
            // profile
            ProfileScreen.routeName: (context) => const MainNavigationScreen(
                initialScreen: MainNavigationScreens.profileScreen),
            //transactions
            TransactionsScreen.routeName: (context) {
              final transactionListFilter = ModalRoute.of(context)
                  ?.settings
                  .arguments as TransactionListFilter?;

              return MainNavigationScreen(
                  initialScreen: MainNavigationScreens.transactionsScreen,
                  screenParams: transactionListFilter);
            },
            TransactionsFilteringScreen.routeName: (context) {
              final transactionListFilter = ModalRoute.of(context)
                  ?.settings
                  .arguments as TransactionListFilter?;

              return TransactionsFilteringScreen(
                transactionListFilter: transactionListFilter,
              );
            },
            // wallet
            WalletScreen.routeName: (context) => const MainNavigationScreen(
                initialScreen: MainNavigationScreens.walletScreen),
            CardDetailsScreen.routeName: (context) {
              final cardDetailsScreenParams = ModalRoute.of(context)
                  ?.settings
                  .arguments as CardDetailsScreenParams?;

              return CardDetailsScreen(
                params: cardDetailsScreenParams!,
              );
            },
            // repayments
            RepaymentsScreen.routeName: (context) => const RepaymentsScreen(),
            // transfer
            TransferScreen.routeName: (context) {
              final transferScreenParams = ModalRoute.of(context)
                  ?.settings
                  .arguments as TransferScreenParams?;

              return TransferScreen(
                transferScreenParams: transferScreenParams!,
              );
            },
            // account
            AccountDetailsScreen.routeName: (context) =>
                const AccountDetailsScreen(),
            // splitpay
            SplitpayScreen.routeName: (context) {
              final splitpayScreenParams = ModalRoute.of(context)
                  ?.settings
                  .arguments as SplitpayScreenParams?;
              return SplitpayScreen(
                params: splitpayScreenParams!,
              );
            }
          },
        );
      }),
    );
  }
}
