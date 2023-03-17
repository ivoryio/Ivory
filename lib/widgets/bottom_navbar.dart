import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../router/router.dart';

PlatformNavBar createBottomNavbar(BuildContext context) {
  final currentPageIndex = AppRouter.calculateSelectedIndex(context);

  return PlatformNavBar(
    material: (context, platform) => MaterialNavBarData(
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      selectedItemColor: Colors.black,
    ),
    cupertino: (context, platform) => CupertinoTabBarData(
      backgroundColor: Colors.white,
      activeColor: Colors.black,
    ),
    currentIndex: currentPageIndex,
    itemChanged: (pageIndex) {
      if (pageIndex == currentPageIndex) {
        return;
      }

      AppRouter.navigateToPage(pageIndex, context);
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