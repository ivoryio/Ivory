import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/models/person_account_summary.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:solarisdemo/widgets/screen.dart';

import '../../models/user.dart';
import '../../utilities/format.dart';
import '../../widgets/analytics.dart';
import '../../widgets/bottom_navbar.dart';
import '../../widgets/refer_a_friend.dart';
import '../../services/person_service.dart';
import '../../widgets/transaction_list.dart';
import '../../widgets/account_balance_text.dart';
import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../cubits/account_summary_cubit/account_summary_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User user = context.read<AuthCubit>().state.user!;

    return Screen(
      title: 'Hello, ${user.firstName}!',
      hideBackButton: true,
      appBarColor: const Color(0xFF1C1A28),
      trailingActions: [
        PlatformIconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.bar_chart,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        PlatformIconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.notifications_none,
            color: Colors.white,
          ),
          onPressed: () {},
        )
      ],
      titleTextStyle: const TextStyle(color: Colors.white),
      child: const HomePageContent(),
    );
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 44),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            HomePageHeader(),
            TransactionList(),
            Analytics(),
            ReferAFriend(),
          ],
        ),
      ),
    );
  }
}

class HomePageHeader extends StatelessWidget {
  const HomePageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    User user = context.read<AuthCubit>().state.user!;
    return BlocProvider(
      create: (context) =>
          AccountSummaryCubit(personService: PersonService(user: user))
            ..getAccountSummary(),
      child: BlocBuilder<AccountSummaryCubit, AccountSummaryCubitState>(
        builder: (context, state) {
          if (state is AccountSummaryCubitLoading) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                    account: state.data?.account,
                    income: state.data?.income,
                    spending: state.data?.spending,
                  ),
                  AccountOptions(),
                ],
              ),
            );
          }

          return Text("Could not load account summary");
        },
      ),
    );
  }
}

class AccountSummary extends StatelessWidget {
  final Account? account;
  final num? income;
  final num? spending;

  const AccountSummary(
      {super.key,
      required this.account,
      required this.income,
      required this.spending});

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
            iban: account?.iban ?? "",
            value: (account?.balance.value ?? 0).toDouble(),
          ),
          AccountStats(
            income: income ?? 0,
            spending: spending ?? 0,
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
            onPressed: () => print("Top up"),
          ),
          AccountOptionsButton(
            textLabel: "Send",
            icon: Icons.compare_arrows,
            onPressed: () => print("Send"),
          ),
          AccountOptionsButton(
            textLabel: "Request",
            icon: Icons.receipt_long,
            onPressed: () => print("Request"),
          ),
          AccountOptionsButton(
            textLabel: "Acc. details",
            icon: Icons.info,
            onPressed: () => print("Acc. details"),
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
