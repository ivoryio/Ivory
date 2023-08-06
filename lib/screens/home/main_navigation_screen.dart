import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solarisdemo/screens/home/home_screen.dart';
import 'package:solarisdemo/screens/profile/profile_screen.dart';
import 'package:solarisdemo/screens/transactions/transactions_screen.dart';
import 'package:solarisdemo/screens/wallet/wallet_screen.dart';

enum MainNavigationScreens {
  homeScreen,
  walletScreen,
  transactionsScreen,
  profileScreen,
}

final List<MainNavigationScreens> mainNavigationScreens = [
  MainNavigationScreens.homeScreen,
  MainNavigationScreens.walletScreen,
  MainNavigationScreens.transactionsScreen,
  MainNavigationScreens.profileScreen,
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
    return Scaffold(
      backgroundColor: _getBackgroundColor(),
      appBar: AppBar(
        backgroundColor: _getStatusBarColor(),
        toolbarHeight: 0,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: _getStatusBarColor(),
          statusBarIconBrightness: _getStatusBarIconBrightness(),
          statusBarBrightness: _getStatusBarIconBrightness() == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
        ),
      ),
      body: _getBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _getBody() {
    switch (mainNavigationScreens[currentPageIndex]) {
      case MainNavigationScreens.homeScreen:
        return const HomeScreen();
      case MainNavigationScreens.walletScreen:
        return const WalletScreen();
      case MainNavigationScreens.transactionsScreen:
        return TransactionsScreen(transactionListFilter: widget.screenParams);
      case MainNavigationScreens.profileScreen:
        return const ProfileScreen();
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
    );
  }

  Color _getBackgroundColor() {
    return Colors.white;
  }

  Color _getStatusBarColor() {
    switch (mainNavigationScreens[currentPageIndex]) {
      case MainNavigationScreens.homeScreen:
        return const Color(0xFF1C1A28);
      default:
        return Colors.transparent;
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
