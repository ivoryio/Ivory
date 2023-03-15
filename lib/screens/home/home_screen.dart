import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:solaris_structure_1/themes/default_theme.dart';

import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../cubits/person_cubit/person_cubit.dart';
import '../../models/oauth_model.dart';
import '../../models/person_model.dart';
import '../../router/router.dart';
import '../../services/person_service.dart';
import '../../widgets/transaction_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    OauthModel oAuth = context.read<AuthCubit>().state.oauthModel!;

    return BlocProvider(
      create: (context) => PersonCubit(
        personService: PersonService(oauth: oAuth),
      )..getPerson(),
      child: BlocBuilder<PersonCubit, PersonCubitState>(
        builder: (context, state) {
          if (state is PersonCubitInitial || state is PersonCubitLoading) {
            return PlatformScaffold(
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is PersonCubitLoaded) {
            var person = state.person!;

            return PlatformScaffold(
                iosContentBottomPadding: true,
                iosContentPadding: true,
                appBar: PlatformAppBar(
                  title: Text(
                    'Hello, ${person.firstName}!',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: const Color(0xFF1C1A28),
                  trailingActions: [
                    PlatformIconButton(
                      icon: const Icon(
                        Icons.bar_chart,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                    PlatformIconButton(
                      icon: const Icon(Icons.notifications_none,
                          color: Colors.white),
                      onPressed: () {},
                    )
                  ],
                ),
                body: HomePageContent(person: person),
                bottomNavBar: PlatformNavBar(
                  currentIndex: AppRouter.calculateSelectedIndex(context),
                  itemChanged: (pageIndex) =>
                      AppRouter.navigateToPage(pageIndex, context),
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.add_card),
                      label: 'Wallet',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.payments),
                      label: 'Transactions',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: 'Profile',
                    ),
                  ],
                ));
          }

          return PlatformScaffold(
            body: const Center(
              child: Text("Person could not be loaded"),
            ),
          );
        },
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  final Person person;
  const HomePageContent({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Color(0xFF272735),
                ),
                child: Column(
                  children: [
                    Container(
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
                          PlatformText(
                            "Total Balance",
                            style: const TextStyle(color: Colors.white),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                PlatformText(
                                  "€ 20,000",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                PlatformText(
                                  ".00",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          PlatformText(
                            "IBAN: ABCD EFGH IJKL MNOP",
                            style: const TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              PlatformText("Income",
                                  style: const TextStyle(color: Colors.white)),
                              const SizedBox(width: 5),
                              PlatformText("€ 12,503.00",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Row(
                            children: [
                              PlatformText(
                                "Spending",
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(width: 5),
                              PlatformText("€ 2,503.00",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF272735),
                            fixedSize: const Size(50, 50),
                            shape: const CircleBorder(),
                            splashFactory: NoSplash.splashFactory,
                          ),
                          child: const Icon(Icons.add_card),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: PlatformText(
                            "Top up",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF272735),
                            fixedSize: const Size(50, 50),
                            shape: const CircleBorder(),
                            splashFactory: NoSplash.splashFactory,
                          ),
                          child: const Icon(Icons.compare_arrows),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: PlatformText(
                            "Send",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF272735),
                            fixedSize: const Size(50, 50),
                            shape: const CircleBorder(),
                            splashFactory: NoSplash.splashFactory,
                          ),
                          child: const Icon(Icons.receipt_long),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: PlatformText(
                            "Request",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF272735),
                            fixedSize: const Size(50, 50),
                            shape: const CircleBorder(),
                            splashFactory: NoSplash.splashFactory,
                          ),
                          child: const Icon(Icons.info),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: PlatformText(
                            "Acc. details",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        TransactionList()
      ],
    );
  }
}
