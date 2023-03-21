const splashScreenRoute = _Route(
  name: 'splash',
  path: '/splash',
  title: 'Splash',
);

const landingRoute = _Route(
  name: 'landing',
  path: '/',
  title: 'Landing',
);

const loginRoute = _Route(
  name: 'login',
  path: '/login',
  title: 'Login',
);

const loginPasscodeRoute = _Route(
  name: 'loginPasscode',
  path: '/login/:user',
  title: 'Login',
);

const signupRoute = _Route(
  name: 'signup',
  path: '/signup',
  title: 'Signup',
);

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
