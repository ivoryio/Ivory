import 'package:flutter/material.dart';
import 'package:solarisdemo/models/home/iulius_navigation_screens.dart';
import 'package:solarisdemo/screens/home/iulius_home_screen.dart';
import 'package:solarisdemo/screens/transactions/transactions_screen.dart';
import 'package:solarisdemo/screens/wallet/cards_screen.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../config.dart';

final List<IuliusNavigationScreens> iuliusNavigationScreens = [
  IuliusNavigationScreens.homeScreen,
  IuliusNavigationScreens.cardsScreen,
  IuliusNavigationScreens.transactionsScreen,
  IuliusNavigationScreens.discountsScreen,
  IuliusNavigationScreens.parkingScreen,
];


class IuliusNavigationScreen extends StatefulWidget {
  final IuliusNavigationScreens initialScreen;
  final dynamic screenParams;

  const IuliusNavigationScreen({
    super.key,
    required this.initialScreen,
    this.screenParams,
  });

  @override
  State<IuliusNavigationScreen> createState() => _IuliusNavigationScreennState();
}

class _IuliusNavigationScreennState extends State<IuliusNavigationScreen> {
  late int currentPageIndex;

  @override
  void initState() {
    super.initState();
    currentPageIndex = iuliusNavigationScreens.indexOf(widget.initialScreen);
  }

  @override
  Widget build(BuildContext context) {
    return MainNavigationScreenScaffold(
      backgroundColor: _getBackgroundColor(),
      statusBarColor: _getStatusBarColor(),
      statusBarIconBrightness: _getStatusBarIconBrightness(),
      body: _getBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _getBody() {
    switch (widget.initialScreen) {
      case IuliusNavigationScreens.homeScreen:
        return const IuliusHomeScreen();
      case IuliusNavigationScreens.cardsScreen:
        return const BankCardsScreen();
      case IuliusNavigationScreens.transactionsScreen:
        return const TransactionsScreen();
      case IuliusNavigationScreens.discountsScreen:
        return const TransactionsScreen();
      case IuliusNavigationScreens.parkingScreen:
        return const TransactionsScreen();    
    }
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentPageIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: ClientConfig.getColorScheme().secondary,
      unselectedItemColor: ClientConfig.getCustomColors().neutral500,
      elevation: 0,
      onTap: (index) {
        setState(() {
          currentPageIndex = index;
        });
      },
      items: iuliusNavigationScreens.map((screen) => _getBottomNavbarItem(screen)).toList(),
    );
  }

  Color _getBackgroundColor() {
    return Colors.white;
  }

  Color _getStatusBarColor() {
    switch (iuliusNavigationScreens[currentPageIndex]) {
      case IuliusNavigationScreens.homeScreen:
        return ClientConfig.getColorScheme().primary;
      default:
        return Colors.transparent;
    }
  }

  BottomNavigationBarItem _getBottomNavbarItem(IuliusNavigationScreens screen) {
    switch (screen) {
      case IuliusNavigationScreens.homeScreen:
        return const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        );
      case IuliusNavigationScreens.cardsScreen:
        return const BottomNavigationBarItem(
          icon: Icon(Icons.credit_card_outlined),
          label: 'Cards',
        );
      case IuliusNavigationScreens.transactionsScreen:
        return const BottomNavigationBarItem(
          icon: Icon(Icons.payments_outlined),
          label: 'Transactions',
        );
      case IuliusNavigationScreens.discountsScreen:
        return const BottomNavigationBarItem(
          icon: Icon(Icons.percent),
          label: 'Discounts',
        );
      case IuliusNavigationScreens.parkingScreen:
        return const BottomNavigationBarItem(
          icon: Icon(Icons.local_parking),
          label: 'Parking',
        );    
    }
  }

  Brightness _getStatusBarIconBrightness() {
    switch (iuliusNavigationScreens[currentPageIndex]) {
      case IuliusNavigationScreens.homeScreen:
        return Brightness.light;
      default:
        return Brightness.dark;
    }
  }
}