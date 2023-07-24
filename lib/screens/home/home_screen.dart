import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../models/user.dart';
import '../../widgets/modal.dart';
import '../../widgets/screen.dart';
import '../../utilities/format.dart';
import '../../widgets/analytics.dart';
import 'modals/new_transfer_popup.dart';
import '../../themes/default_theme.dart';
import '../../widgets/refer_a_friend.dart';
import '../../services/person_service.dart';
import '../../widgets/transaction_list.dart';
import '../../router/routing_constants.dart';
import '../../services/transaction_service.dart';
import '../../widgets/account_balance_text.dart';
import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../cubits/account_summary_cubit/account_summary_cubit.dart';
import '../../cubits/transaction_list_cubit/transaction_list_cubit.dart';

const _defaultCountTransactionsDisplayed = 3;
const _defaultPage = 1;
const _defaultSort = '-recorded_at';
const _defaultTransactionListFilter = TransactionListFilter(
  size: _defaultCountTransactionsDisplayed,
  page: _defaultPage,
  sort: _defaultSort,
);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthenticatedUser user = context.read<AuthCubit>().state.user!;

    AccountSummaryCubit accountSummaryCubit =
        AccountSummaryCubit(personService: PersonService(user: user.cognito))
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
      title: 'Hello, ${user.cognito.firstName}!',
      hideBackButton: true,
      appBarColor: const Color(0xFF1C1A28),
      trailingActions: [
        IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.bar_chart,
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
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  final AccountSummaryCubit accountSummaryCubit;
  final TransactionListCubit transactionListCubit;

  const HomePageContent({
    super.key,
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
            accountSummaryCubit: accountSummaryCubit,
          ),
          Padding(
            padding: defaultScreenPadding,
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
          const Padding(
            padding: defaultScreenPadding,
            child: Analytics(),
          ),
          const Padding(
            padding: defaultScreenPadding,
            child: ReferAFriend(),
          ),
        ],
      ),
    );
  }
}

class HomePageHeader extends StatelessWidget {
  final AccountSummaryCubit accountSummaryCubit;
  const HomePageHeader({
    super.key,
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
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: defaultScreenHorizontalPadding,
              ),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                color: Color(0xFF1C1A28),
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
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: defaultScreenHorizontalPadding,
              ),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                color: Color(0xFF1C1A28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AccountSummary(
                    iban: state.data?.iban ?? "",
                    income: state.data?.income ?? 0,
                    spending: state.data?.spending ?? 0,
                    availableBalance: state.data?.availableBalance?.value ?? 0,
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
  final String iban;
  final num availableBalance;
  final num income;
  final num spending;

  const AccountSummary({
    super.key,
    required this.iban,
    required this.availableBalance,
    required this.income,
    required this.spending,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Color(0xFF272735),
      ),
      child: Column(
        children: [
          AccountBalance(
            iban: iban,
            value: availableBalance,
          ),
          AccountStats(
            income: income,
            spending: spending,
          ),
        ],
      ),
    );
  }
}

class AccountBalance extends StatelessWidget {
  final String iban;
  final num value;

  const AccountBalance({
    super.key,
    required this.value,
    required this.iban,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        color: Colors.black,
      ),
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          const Text(
            "Total Balance",
            style: TextStyle(color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AccountBalanceText(
                  value: value,
                  numberStyle: const TextStyle(color: Colors.white),
                  centsStyle: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Text(
            "IBAN: ${Format.iban(iban)}",
            style: const TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}

class AccountStats extends StatelessWidget {
  final num income;
  final num spending;

  const AccountStats({
    super.key,
    required this.income,
    required this.spending,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text("Income",
                  style: TextStyle(
                    color: Colors.white,
                  )),
              const SizedBox(width: 5),
              Text(Format.euro(income),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
          Row(
            children: [
              const Text(
                "Spending",
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(width: 5),
              Text(
                Format.euro(spending),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
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
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AccountOptionsButton(
            textLabel: "Top up",
            icon: Icons.add_card,
            onPressed: () => log("Top up"),
          ),
          AccountOptionsButton(
            textLabel: "Send",
            icon: Icons.compare_arrows,
            onPressed: () => showBottomModal(
              context: context,
              child: const NewTransferPopup(),
            ),
          ),
          AccountOptionsButton(
            textLabel: "Request",
            icon: Icons.receipt_long,
            onPressed: () => log("Request"),
          ),
          AccountOptionsButton(
            textLabel: "Acc. details",
            icon: Icons.info,
            onPressed: () => log("Acc. details"),
          ),
        ],
      ),
    );
  }
}

class AccountOptionsButton extends StatelessWidget {
  final String textLabel;
  final IconData icon;
  final Function onPressed;

  const AccountOptionsButton(
      {super.key,
      required this.textLabel,
      required this.icon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => onPressed(),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF272735),
            fixedSize: const Size(50, 50),
            shape: const CircleBorder(),
            splashFactory: NoSplash.splashFactory,
          ),
          child: Icon(icon, color: Colors.white),
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
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (displayShowAllButton)
          TextButton(
            child: const Text(
              "See all",
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              context.push(transactionsRoute.path);
            },
          )
      ],
    );
  }
}
