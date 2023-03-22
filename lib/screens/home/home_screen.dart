import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:solaris_structure_1/cubits/person_account/person_account_cubit.dart';
import 'package:solaris_structure_1/utilities/format.dart';
import 'package:solaris_structure_1/widgets/account_balance_text.dart';
import 'package:solaris_structure_1/widgets/refer_a_friend.dart';

import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../cubits/person_cubit/person_cubit.dart';
import '../../models/oauth_model.dart';
import '../../models/person_account.dart';
import '../../models/person_model.dart';
import '../../services/auth_service.dart';
import '../../services/person_service.dart';
import '../../widgets/analytics.dart';
import '../../widgets/bottom_navbar.dart';
import '../../widgets/screen.dart';
import '../../widgets/transaction_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // OauthModel oAuth = context.read<AuthCubit>().state.oauthModel!;
    // PersonService personService = PersonService(oauth: oAuth);
    User user = context.read<AuthCubit>().state.user!;
    inspect(user);

    return Screen(
      title: "Home",
      child: Center(
        child: Text("home"),
      ),
    );

    // return BlocProvider(
    //   create: (context) => PersonCubit(
    //     personService: personService,
    //   )..getPerson(),
    //   child: BlocBuilder<PersonCubit, PersonCubitState>(
    //     builder: (context, state) {
    //       if (state is PersonCubitInitial || state is PersonCubitLoading) {
    //         return PlatformScaffold(
    //           body: const Center(
    //             child: CircularProgressIndicator(),
    //           ),
    //         );
    //       }

    //       if (state is PersonCubitLoaded) {
    //         var person = state.person!;

    //         return PlatformScaffold(
    //           iosContentBottomPadding: true,
    //           iosContentPadding: true,
    //           appBar: PlatformAppBar(
    //             title: Text(
    //               'Hello, ${person.firstName}!',
    //               style: const TextStyle(color: Colors.white),
    //             ),
    //             backgroundColor: const Color(0xFF1C1A28),
    //             cupertino: (context, platform) => CupertinoNavigationBarData(
    //               automaticallyImplyLeading: false,
    //             ),
    //             material: (context, platform) => MaterialAppBarData(
    //               automaticallyImplyLeading: false,
    //               elevation: 0,
    //             ),
    //             trailingActions: [
    //               PlatformIconButton(
    //                 padding: EdgeInsets.zero,
    //                 icon: const Icon(
    //                   Icons.bar_chart,
    //                   color: Colors.white,
    //                 ),
    //                 onPressed: () {},
    //               ),
    //               PlatformIconButton(
    //                 padding: EdgeInsets.zero,
    //                 icon: const Icon(
    //                   Icons.notifications_none,
    //                   color: Colors.white,
    //                 ),
    //                 onPressed: () {},
    //               )
    //             ],
    //           ),
    //           body: HomePageContent(person: person),
    //           bottomNavBar: createBottomNavbar(context),
    //         );
    //       }

    //       return PlatformScaffold(
    //         body: const Center(
    //           child: Text("Person could not be loaded"),
    //         ),
    //       );
    //     },
    //   ),
    // );
  }
}

class HomePageContent extends StatelessWidget {
  final Person person;
  const HomePageContent({super.key, required this.person});

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
        children: const [
          AccountSummary(),
          AccountOptions(),
        ],
      ),
    );
  }
}

class AccountSummary extends StatelessWidget {
  const AccountSummary({super.key});

  @override
  Widget build(BuildContext context) {
    OauthModel oAuth = context.read<AuthCubit>().state.oauthModel!;
    PersonService personService = PersonService(oauth: oAuth);

    return BlocProvider(
      create: (context) =>
          PersonAccountCubit(personService: personService)..getPersonAccounts(),
      child: BlocBuilder<PersonAccountCubit, PersonAccountState>(
        builder: (context, state) {
          if (state is PersonAccountInitial || state is PersonAccountLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (state is PersonAccountLoaded) {
            PersonAccount account = state.personAccount!;

            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Color(0xFF272735),
              ),
              child: Column(
                children: [
                  AccountBalance(
                    iban: account.iban!,
                    cents: account.balance?.value ?? 0.0,
                  ),
                  const AccountStats(
                    income: 1234.56,
                    spending: 78.91,
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text("Account could not be loaded"),
          );
        },
      ),
    );
  }
}

class AccountBalance extends StatelessWidget {
  final String iban;
  final num cents;

  const AccountBalance({
    super.key,
    required this.cents,
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
              children: const [
                AccountBalanceText(
                  numberStyle: TextStyle(color: Colors.white),
                  centsStyle: TextStyle(color: Colors.white),
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
  final double income;
  final double spending;

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
