const String loginPageRouteName = 'login';
const String homePageRouteName = 'home';
const String transferPageRouteName = 'transfer';
const String hubPageRouteName = 'hub';
const String splashScreenRouteName = 'splash';

const String loginPageRoutePath = '/login';
const String homePageRoutePath = '/home';
const String transferPageRoutePath = '/transfer';
const String hubPageRoutePath = '/hub';
const String splashScreenRoutePath = '/splash';

class _Route {
  final String name;
  final String path;
  final String title;
  final int? navbarIndex;

  const _Route({
    required this.name,
    required this.path,
    required this.title,
    this.navbarIndex,
  });
}

const homeRoute = _Route(
  name: 'home',
  path: '/home',
  title: 'Home',
  navbarIndex: 0,
);

const walletRoute = _Route(
  name: 'wallet',
  path: '/wallet',
  title: 'Wallet',
  navbarIndex: 1,
);

const transactionsRoute = _Route(
  name: 'transactions',
  path: '/transactions',
  title: 'Transactions',
  navbarIndex: 2,
);

const profileRoute = _Route(
  name: 'profile',
  path: '/profile',
  title: 'Profile',
  navbarIndex: 3,
);
