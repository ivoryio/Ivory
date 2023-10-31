import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:solarisdemo/infrastructure/person/account_summary/account_summary_presenter.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/screens/account/account_details_screen.dart';
import 'package:solarisdemo/screens/available_balance/available_balance_screen.dart';
import 'package:solarisdemo/screens/onboarding/personal_details/onboarding_adress_of_residence_screen.dart';
import 'package:solarisdemo/screens/repayments/repayments_screen.dart';
import 'package:solarisdemo/screens/transactions/transactions_screen.dart';
import 'package:solarisdemo/screens/transfer/transfer_screen.dart';
import 'package:solarisdemo/widgets/rewards.dart';
import 'package:solarisdemo/widgets/screen.dart';

import '../../config.dart';
import '../../infrastructure/transactions/transaction_presenter.dart';
import '../../models/transactions/transaction_model.dart';
import '../../redux/app_state.dart';
import '../../redux/person/account_summary/account_summay_action.dart';
import '../../redux/transactions/transactions_action.dart';
import '../../widgets/account_balance_text.dart';
import '../../widgets/analytics.dart';
import '../../widgets/transaction_listing_item.dart';

const _defaultCountTransactionsDisplayed = 3;
const _defaultPage = 1;
const _defaultSort = '-recorded_at';
const _defaultTransactionListFilter = TransactionListFilter(
  size: _defaultCountTransactionsDisplayed,
  page: _defaultPage,
  sort: _defaultSort,
);

class HomeScreen extends StatelessWidget {
  static const routeName = "/homeScreen";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = (StoreProvider.of<AppState>(context).state.authState as AuthenticatedState).authenticatedUser;

    return Screen(
      title: 'Welcome ${user.cognito.firstName}!',
      hideBackButton: true,
      appBarColor: ClientConfig.getColorScheme().primary,
      trailingActions: [
        IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.remove_red_eye_outlined,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.notifications_none,
            color: Colors.white,
          ),
          onPressed: () {},
        )
      ],
      titleTextStyle: ClientConfig.getTextStyleScheme().heading3.copyWith(color: Colors.white),
      centerTitle: false,
      child: const HomePageContent(),
    );
  }
}

class HomePageContent extends StatelessWidget {

  const HomePageContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 44),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomePageHeader(),
          Column(
            children: [
              Padding(
                padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                child: const TransactionListTitle(
                  displayShowAllButton: true,
                ),
              ),
              StoreConnector<AppState, TransactionsViewModel>(
                onInit: (store) => store.dispatch(
                  GetHomeTransactionsCommandAction(
                    filter: _defaultTransactionListFilter,
                    forceReloadTransactions: false,
                  ),
                ),
                converter: (store) =>
                    TransactionPresenter.presentTransactions(transactionsState: store.state.homePageTransactionsState),
                builder: (context, viewModel) {
                  if (viewModel is TransactionsErrorViewModel) {
                    return const Center(
                      child: Text('Could not load transactions'),
                    );
                  }

                  if (viewModel is TransactionsFetchedViewModel) {
                    return Column(
                      children: [
                        for (var transaction in viewModel.transactions!)
                          TransactionListItem(
                            transaction: transaction,
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 24,
                            horizontal: 24,
                          ),
                          child: Analytics(
                            transactions: viewModel.transactions!,
                          ),
                        ),
                      ],
                    );
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
          Padding(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            child: const Rewards(),
          ),
        ],
      ),
    );
  }
}

class HomePageHeader extends StatelessWidget {

  const HomePageHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AccountSummaryViewModel>(
      onInit: (store) {
        store.dispatch(GetAccountSummaryCommandAction(forceAccountSummaryReload: false));
      },
      converter: (store) =>
          AccountSummaryPresenter.presentAccountSummary(accountSummaryState: store.state.accountSummaryState),
        builder: (context, viewModel) {
          if (viewModel is AccountSummaryFetchedViewModel || viewModel is AccountSummaryLoadingViewModel) {
            return Container(
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                color: ClientConfig.getColorScheme().primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (viewModel is AccountSummaryFetchedViewModel)
                    AccountSummary(
                     viewModel: viewModel,
                    )
                  else
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                  const Divider(
                    color: Colors.white,
                    thickness: 0.5,
                  ),
                  const AccountOptions(),
                ],
              ),
            );
          }

          return const Text("Could not load account summary");
        },
    );
  }
}

class AccountSummary extends StatelessWidget {
  final AccountSummaryFetchedViewModel viewModel;

  const AccountSummary({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AccountBalance(
          viewModel: viewModel,
        ),
        AccountStats(
         viewModel: viewModel,
        ),
      ],
    );
  }
}

class AccountBalance extends StatelessWidget {
  final AccountSummaryFetchedViewModel viewModel;

  const AccountBalance({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Available Balance",
              style: ClientConfig.getTextStyleScheme().labelSmall.copyWith(color: Colors.white),
            ),
            IconButton(
              icon: const Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(AvailableBalanceScreen.routeName, arguments: viewModel);
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: AccountBalanceText(
            value: viewModel.accountSummary?.availableBalance?.value ?? 0,
            numberStyle: ClientConfig.getTextStyleScheme().display.copyWith(color: Colors.white),
            centsStyle: const TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
        LinearPercentIndicator(
          lineHeight: 8,
          barRadius: const Radius.circular(40),
          percent: ((viewModel.accountSummary?.outstandingAmount ?? 0) / (viewModel.accountSummary?.creditLimit ?? 0)).isInfinite
              ? 0
              : (viewModel.accountSummary?.outstandingAmount ?? 0) / (viewModel.accountSummary?.creditLimit ?? 0.01),
          backgroundColor: const Color(0x26F8F9FA),
          progressColor: ClientConfig.getColorScheme().secondary,
          curve: Curves.fastOutSlowIn,
        ),
      ],
    );
  }
}

class AccountStats extends StatelessWidget {
  final AccountSummaryFetchedViewModel viewModel;

  const AccountStats({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Outstanding balance",
                style: ClientConfig.getTextStyleScheme().labelSmall.copyWith(color: Colors.white),
              ),
              const SizedBox(width: 5),
              AccountBalanceText(
                value: viewModel.accountSummary?.outstandingAmount ?? 0,
                numberStyle: ClientConfig.getTextStyleScheme().labelLarge.copyWith(color: Colors.white),
                centsStyle: ClientConfig.getTextStyleScheme().labelSmall.copyWith(color: Colors.white),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Credit limit",
                style: ClientConfig.getTextStyleScheme().labelSmall.copyWith(color: Colors.white),
              ),
              const SizedBox(width: 5),
              AccountBalanceText(
                value: viewModel.accountSummary?.creditLimit ?? 0.01,
                numberStyle: ClientConfig.getTextStyleScheme().labelLarge.copyWith(color: Colors.white),
                centsStyle: ClientConfig.getTextStyleScheme().labelSmall.copyWith(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AccountOptions extends StatelessWidget {
  const AccountOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 24,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AccountOptionsButton(
            textLabel: "Transfer",
            icon: const ImageIcon(
              AssetImage('assets/icons/compare_arrows.png'),
              size: 24,
            ),
            onPressed: () => Navigator.pushNamed(context, TransferScreen.routeName),
          ),
          AccountOptionsButton(
            textLabel: "Repayments",
            icon: const ImageIcon(
              AssetImage('assets/icons/currency_exchange_euro_repay.png'),
              size: 24,
            ),
            onPressed: () => Navigator.pushNamed(context, RepaymentsScreen.routeName),
          ),
          AccountOptionsButton(
            textLabel: "Account",
            icon: const ImageIcon(
              AssetImage('assets/icons/info.png'),
              size: 24,
            ),
            // onPressed: () => Navigator.pushNamed(context, AccountDetailsScreen.routeName),
            onPressed: () => Navigator.pushNamed(context, OnboardingAddressOfResidenceScreen.routeName),
            
          ),
        ],
      ),
    );
  }
}

class AccountOptionsButton extends StatelessWidget {
  final String textLabel;
  final Widget icon;
  final Function onPressed;

  const AccountOptionsButton({super.key, required this.textLabel, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => onPressed(),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFFFFF),
            fixedSize: const Size(50, 50),
            shape: const CircleBorder(),
            splashFactory: NoSplash.splashFactory,
          ),
          child: Center(
            child: IconButton(
              icon: icon,
              splashColor: Colors.transparent,
              color: Colors.black,
              onPressed: () => onPressed(),
              iconSize: 24,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            textLabel,
            style: ClientConfig.getTextStyleScheme().labelSmall.copyWith(color: Colors.white),
          ),
        )
      ],
    );
  }
}

class TransactionListTitle extends StatelessWidget {
  final bool displayShowAllButton;

  const TransactionListTitle({
    super.key,
    this.displayShowAllButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
         Text(
          "Transactions",
          style: ClientConfig.getTextStyleScheme().labelLarge,
        ),
        if (displayShowAllButton)
          TextButton(
            child: Text(
              "See all",
              textAlign: TextAlign.right,
              style: ClientConfig.getTextStyleScheme().labelMedium.copyWith(color: ClientConfig.getColorScheme().secondary),
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                TransactionsScreen.routeName,
              );
            },
          )
      ],
    );
  }
}
