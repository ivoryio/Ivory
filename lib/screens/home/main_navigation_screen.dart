import 'package:flutter/material.dart';
import 'package:solarisdemo/models/home/main_navigation_screens.dart';
import 'package:solarisdemo/screens/home/home_screen.dart';
import 'package:solarisdemo/screens/settings/settings_screen.dart';
import 'package:solarisdemo/screens/transactions/transactions_screen.dart';
import 'package:solarisdemo/screens/wallet/cards_screen.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

final List<MainNavigationScreens> mainNavigationScreens = [
  MainNavigationScreens.homeScreen,
  MainNavigationScreens.cardsScreen,
  MainNavigationScreens.transactionsScreen,
  MainNavigationScreens.settingsScreen,
];

class MainNavigationScreen extends StatefulWidget {
  final MainNavigationScreens initialScreen;
  final dynamic screenParams;

  const MainNavigationScreen({
    super.key,
    required this.initialScreen,
    this.screenParams,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int currentPageIndex;

  @override
  void initState() {
    super.initState();
    currentPageIndex = mainNavigationScreens.indexOf(widget.initialScreen);
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
    switch (mainNavigationScreens[currentPageIndex]) {
      case MainNavigationScreens.homeScreen:
        return const HomeScreen();
      case MainNavigationScreens.cardsScreen:
        return const CardsScreen();
      case MainNavigationScreens.transactionsScreen:
        return const TransactionsScreen();
      case MainNavigationScreens.settingsScreen:
        return const SettingsScreen();
    }
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentPageIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 0,
      onTap: (index) {
        setState(() {
          currentPageIndex = index;
        });
      },
      items: mainNavigationScreens.map((screen) => _getBottomNavbarItem(screen)).toList(),
    );
  }

  Color _getBackgroundColor() {
    return Colors.white;
  }

  Color _getStatusBarColor() {
    switch (mainNavigationScreens[currentPageIndex]) {
      case MainNavigationScreens.homeScreen:
        return const Color(0xFF000000);
      default:
        return Colors.transparent;
    }
  }

  BottomNavigationBarItem _getBottomNavbarItem(MainNavigationScreens screen) {
    switch (screen) {
      case MainNavigationScreens.homeScreen:
        return const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        );
      case MainNavigationScreens.cardsScreen:
        return const BottomNavigationBarItem(
          icon: Icon(Icons.credit_card_outlined),
          label: 'Cards',
        );
      case MainNavigationScreens.transactionsScreen:
        return const BottomNavigationBarItem(
          icon: Icon(Icons.payments_outlined),
          label: 'Transactions',
        );
      case MainNavigationScreens.settingsScreen:
        return const BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: 'Settings',
        );
    }
  }

  Brightness _getStatusBarIconBrightness() {
    switch (mainNavigationScreens[currentPageIndex]) {
      case MainNavigationScreens.homeScreen:
        return Brightness.light;
      default:
        return Brightness.dark;
    }
  }
}
