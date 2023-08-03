import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solarisdemo/models/bank_card.dart';
import 'package:solarisdemo/screens/repayments/repayments_screen.dart';
import 'package:solarisdemo/screens/splitpay/splitpay_screen.dart';
import 'package:solarisdemo/screens/transactions/transactions_filtering_screen.dart';
import 'package:solarisdemo/widgets/screen.dart';

import '../cubits/auth_cubit/auth_cubit.dart';
import '../models/transaction_model.dart';
import '../screens/home/home_screen.dart';
import '../screens/landing/landing_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/signup/signup_screen.dart';
import '../screens/transactions/transactions_screen.dart';
import '../screens/transfer/transfer_screen.dart';
import '../screens/wallet/card_details_screen.dart';
import '../screens/wallet/wallet_screen.dart';
import '../services/transaction_service.dart';
import 'routing_constants.dart';

class AppRouter {
  final _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'rootNavigatorKey');

  final AuthCubit loginCubit;
  AppRouter(this.loginCubit);

  late final router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: landingRoute.path,
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
            path: landingRoute.path,
            name: landingRoute.name,
            builder: (BuildContext context, GoRouterState state) {
              return const LandingScreen();
            }),
        GoRoute(
          path: loginRoute.path,
          name: loginRoute.name,
          builder: (BuildContext context, GoRouterState state) {
            return const LoginScreen();
          },
        ),
        GoRoute(
          path: signupRoute.path,
          name: signupRoute.name,
          builder: (BuildContext context, GoRouterState state) {
            return const SignupScreen();
          },
        ),
        GoRoute(
          path: homeRoute.path,
          name: homeRoute.name,
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          },
        ),
        GoRoute(
          path: walletRoute.path,
          name: walletRoute.name,
          builder: (BuildContext context, GoRouterState state) {
            return const WalletScreen();
          },
        ),
        GoRoute(
          path: transactionsRoute.path,
          name: transactionsRoute.name,
          builder: (BuildContext context, GoRouterState state) {
            return TransactionsScreen(
              transactionListFilter: state.extra is TransactionListFilter
                  ? state.extra as TransactionListFilter
                  : null,
            );
          },
        ),
        GoRoute(
          path: transactionsFilteringRoute.path,
          name: transactionsFilteringRoute.name,
          builder: (BuildContext context, GoRouterState state) {
            return TransactionsFilteringScreen(
              transactionListFilter: state.extra is TransactionListFilter
                  ? state.extra as TransactionListFilter
                  : null,
            );
          },
        ),
        GoRoute(
          path: profileRoute.path,
          name: profileRoute.name,
          builder: (BuildContext context, GoRouterState state) {
            return const ProfileScreen();
          },
        ),
        GoRoute(
          path: transferRoute.path,
          name: transferRoute.name,
          builder: (BuildContext context, GoRouterState state) {
            TransferScreenParams transferScreenParams = state.extra
                    is TransferScreenParams
                ? state.extra as TransferScreenParams
                : const TransferScreenParams(transferType: TransferType.person);

            return TransferScreen(transferScreenParams: transferScreenParams);
          },
        ),
        GoRoute(
          path: cardDetailsRoute.path,
          name: cardDetailsRoute.name,
          builder: (BuildContext context, GoRouterState state) {
            if (state.extra is! BankCard) {
              return const ErrorScreen();
            }

            final cards = state.extra as BankCard;

            return CardDetailsScreen(card: cards);
          },
        ),
        GoRoute(
          path: splitpaySelectRoute.path,
          name: splitpaySelectRoute.name,
          builder: (BuildContext context, GoRouterState state) {
            return SplitpayScreen(
              transaction: state.extra as Transaction,
            );
          },
        ),
        GoRoute(
          path: repaymentsRoute.path,
          name: repaymentsRoute.name,
          builder: (BuildContext context, GoRouterState state) {
            return const RepaymentsScreen();
          },
        ),
      ],
      redirect: (BuildContext context, GoRouterState state) {
        final bool isAuthenticated =
            loginCubit.state.status == AuthStatus.authenticated;
        final bool isOnLoginPage = state.subloc.startsWith(loginRoute.path);

        if (isAuthenticated && isOnLoginPage) {
          return homeRoute.path;
        }

        return null;
      },
      refreshListenable: GoRouterRefreshStream(loginCubit.stream));

  static int calculateSelectedIndex(BuildContext context) {
    final GoRouter route = GoRouter.of(context);
    final String location = route.location;

    if (location == homeRoute.path) {
      return homeRoute.navbarIndex!;
    }
    if (location == walletRoute.path) {
      return walletRoute.navbarIndex!;
    }
    if (location == transactionsRoute.path) {
      return transactionsRoute.navbarIndex!;
    }
    if (location == profileRoute.path) {
      return profileRoute.navbarIndex!;
    }
    if (location == cardDetailsRoute.path) {
      return walletRoute.navbarIndex!;
    }

    return 0;
  }

  static void navigateToPage(int pageIndex, BuildContext context) {
    if (pageIndex == homeRoute.navbarIndex) {
      context.push(homeRoute.path);
    }
    if (pageIndex == walletRoute.navbarIndex) {
      context.push(walletRoute.path);
    }
    if (pageIndex == transactionsRoute.navbarIndex) {
      context.push(transactionsRoute.path);
    }
    if (pageIndex == profileRoute.navbarIndex) {
      context.push(profileRoute.path);
    }
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((dynamic _) {
      notifyListeners();
    });
  }
  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
