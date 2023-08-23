import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:solarisdemo/infrastructure/transactions/transaction_service.dart';
import 'package:solarisdemo/models/person_account_summary.dart';
import 'package:solarisdemo/models/person_model.dart';
import 'package:solarisdemo/screens/account/account_details_screen.dart';
import 'package:solarisdemo/screens/repayments/repayments_screen.dart';
import 'package:solarisdemo/screens/transactions/transactions_screen.dart';
import 'package:solarisdemo/widgets/rewards.dart';
import 'package:solarisdemo/widgets/screen.dart';
import 'package:solarisdemo/widgets/transaction_list.dart';

import '../../config.dart';
import '../../cubits/account_summary_cubit/account_summary_cubit.dart';
import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../cubits/transaction_list_cubit/transaction_list_cubit.dart';
import '../../models/transactions/transaction_model.dart';
import '../../models/user.dart';
import '../../services/person_service.dart';
import '../../widgets/account_balance_text.dart';
import '../../widgets/analytics.dart';
import '../../widgets/modal.dart';
import 'modals/new_transfer_popup.dart';

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
    AuthenticatedUser user = context.read<AuthCubit>().state.user!;

    AccountSummaryCubit accountSummaryCubit = AccountSummaryCubit(personService: PersonService(user: user.cognito))
      ..getAccountSummary();

    TransactionListCubit transactionListCubit = TransactionListCubit(
      transactionService: TransactionService(user: user.cognito),
    )..getTransactions(filter: _defaultTransactionListFilter);

    return Screen(
      onRefresh: () async {
        accountSummaryCubit.getAccountSummary();
        transactionListCubit.getTransactions(
          filter: _defaultTransactionListFilter,
        );
      },
      title: 'Welcome ${user.cognito.firstName}!',
      hideBackButton: true,
      appBarColor: Colors.black,
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
      titleTextStyle: const TextStyle(color: Colors.white),
      centerTitle: false,
      child: HomePageContent(
        accountSummaryCubit: accountSummaryCubit,
        transactionListCubit: transactionListCubit,
        user: user,
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  final AccountSummaryCubit accountSummaryCubit;
  final TransactionListCubit transactionListCubit;
  final AuthenticatedUser user;

  const HomePageContent({
    super.key,
    required this.user,
    required this.accountSummaryCubit,
    required this.transactionListCubit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 44),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomePageHeader(
            customer: user.person,
            accountSummaryCubit: accountSummaryCubit,
          ),
          Padding(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
            child: Column(
              children: [
                TransactionList(
                  transactionListCubit: transactionListCubit,
                  header: const TransactionListTitle(
                    displayShowAllButton: true,
                  ),
                  filter: const TransactionListFilter(
                    size: _defaultCountTransactionsDisplayed,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
            child: Analytics(
              transactionListCubit: transactionListCubit,
            ),
          ),
          Padding(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
            child: const Rewards(),
          ),
        ],
      ),
    );
  }
}

class HomePageHeader extends StatelessWidget {
  final AccountSummaryCubit accountSummaryCubit;
  final Person customer;

  const HomePageHeader({
    super.key,
    required this.customer,
    required this.accountSummaryCubit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountSummaryCubit>.value(
      value: accountSummaryCubit,
      child: BlocBuilder<AccountSummaryCubit, AccountSummaryCubitState>(
        builder: (context, state) {
          if (state is AccountSummaryCubitLoading) {
            return Container(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
              ),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                color: Color(0xFF000000),
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            );
          }

          if (state is AccountSummaryCubitLoaded) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
              ),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                color: Colors.black,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AccountSummary(
                    spending: state.data?.spending ?? 0,
                    availableBalance: state.data?.availableBalance?.value ?? 0,
                    outstandingAmount: state.data?.outstandingAmount ?? 0,
                    creditLimit: state.data?.creditLimit ?? 0,
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
      ),
    );
  }
}

class AccountSummary extends StatelessWidget {
  final num outstandingAmount;
  final num creditLimit;
  final num availableBalance;
  final num spending;

  const AccountSummary({
    super.key,
    required this.availableBalance,
    required this.spending,
    required this.outstandingAmount,
    required this.creditLimit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AccountBalance(
          value: availableBalance,
        ),
        AccountStats(
          spending: spending,
          creditLimit: creditLimit,
          outstandingAmount: outstandingAmount,
        ),
      ],
    );
  }
}

class AccountBalance extends StatelessWidget {
  final num value;

  const AccountBalance({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    PersonAccountSummary personAccountSummary = context.read<AccountSummaryCubit>().state.data!;

    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Available Balance",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 4,
            ),
            Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AccountBalanceText(
                value: value,
                numberStyle: const TextStyle(color: Colors.white, fontSize: 40),
                centsStyle: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            ],
          ),
        ),
        LinearPercentIndicator(
          lineHeight: 8,
          barRadius: const Radius.circular(40),
          percent: ((personAccountSummary.outstandingAmount ?? 0) / (personAccountSummary.creditLimit ?? 0)).isInfinite
              ? 0
              : (personAccountSummary.outstandingAmount ?? 0) / (personAccountSummary.creditLimit ?? 0.01),
          backgroundColor: const Color(0xFF313038),
          progressColor: const Color(0xFFCC0000),
          curve: Curves.fastOutSlowIn,
        ),
      ],
    );
  }
}

class AccountStats extends StatelessWidget {
  final num spending;
  final num outstandingAmount;
  final num creditLimit;

  const AccountStats({
    super.key,
    required this.spending,
    required this.outstandingAmount,
    required this.creditLimit,
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
              const Text(
                "Outstanding balance",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 5),
              AccountBalanceText(
                value: outstandingAmount,
                numberStyle: const TextStyle(color: Colors.white, fontSize: 18),
                centsStyle: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                "Credit limit",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 5),
              AccountBalanceText(
                value: creditLimit,
                numberStyle: const TextStyle(color: Colors.white, fontSize: 18),
                centsStyle: const TextStyle(color: Colors.white, fontSize: 14),
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
            onPressed: () => showBottomModal(
              context: context,
              title: 'New Transfer',
              content: const NewTransferPopup(),
            ),
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
            onPressed: () => Navigator.pushNamed(context, AccountDetailsScreen.routeName),
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
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
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
        const Text(
          "Transactions",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (displayShowAllButton)
          TextButton(
            child: const Text(
              "See all",
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color(0xFFCC0000),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
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
