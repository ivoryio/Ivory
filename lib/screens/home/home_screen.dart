import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/models/person_model.dart';
import 'package:solarisdemo/screens/account/account_details_screen.dart';
import 'package:solarisdemo/screens/repayments/repayments_screen.dart';
import 'package:solarisdemo/screens/transactions/transactions_screen.dart';

import '../../config.dart';
import '../../cubits/account_summary_cubit/account_summary_cubit.dart';
import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../cubits/transaction_list_cubit/transaction_list_cubit.dart';
import '../../infrastructure/transactions/transaction_service.dart';
import '../../models/transaction_model.dart';
import '../../models/user.dart';
import '../../services/person_service.dart';
import '../../utilities/format.dart';
import '../../widgets/account_balance_text.dart';
import '../../widgets/analytics.dart';
import '../../widgets/modal.dart';
import '../../widgets/refer_a_friend.dart';
import '../../widgets/transaction_list.dart';
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

    return RefreshIndicator(
      onRefresh: () async {
        accountSummaryCubit.getAccountSummary();
        transactionListCubit.getTransactions(
          filter: _defaultTransactionListFilter,
        );
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            HomePageContent(
              user: user,
              accountSummaryCubit: accountSummaryCubit,
              transactionListCubit: transactionListCubit,
            )
          ],
        ),
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
            child: const Analytics(),
          ),
          Padding(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
            child: const ReferAFriend(),
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
              padding: EdgeInsets.symmetric(
                horizontal: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        Text(
                          "Hello, ${customer.firstName}",
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          child: const Icon(
                            Icons.bar_chart,
                            color: Colors.white,
                          ),
                          onTap: () {},
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        InkWell(
                          child: const Icon(
                            Icons.notifications_none,
                            color: Colors.white,
                          ),
                          onTap: () {},
                        )
                      ],
                    ),
                  ),
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
            textLabel: "Transfer",
            icon: Icons.compare_arrows,
            onPressed: () => showBottomModal(
              context: context,
              title: 'New Transfer',
              content: const NewTransferPopup(),
            ),
          ),
          AccountOptionsButton(
            textLabel: "Repayments",
            icon: Icons.receipt_long,
            onPressed: () => Navigator.pushNamed(context, RepaymentsScreen.routeName),
          ),
          AccountOptionsButton(
            textLabel: "Account",
            icon: Icons.info,
            onPressed: () {
              Navigator.pushNamed(context, AccountDetailsScreen.routeName);
            },
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

  const AccountOptionsButton({super.key, required this.textLabel, required this.icon, required this.onPressed});

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
