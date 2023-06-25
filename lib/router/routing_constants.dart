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
  path: '/login/:username',
  title: 'Login',
);

const loginPasscodeErrorRoute = _Route(
  name: 'loginPasscodeError',
  path: '/login/:username/error',
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

const transactionsFilteringRoute = _Route(
  name: 'transactionsFiltering',
  path: '/transactions/filtering',
  title: 'Filter',
);

const profileRoute = _Route(
  name: 'profile',
  path: '/profile',
  title: 'Profile',
  navbarIndex: 3,
);

const transferRoute = _Route(
  name: 'transfer',
  path: '/transfer',
  title: 'Transfer money',
);

const cardDetailsRoute = _Route(
  name: 'cardDetails',
  path: '/card-details',
  title: 'Card details',
);

const splitpaySelectRoute = _Route(
  name: 'splitpay',
  path: '/splitpay',
  title: 'Convert into instalments',
);

const countdownRoute = _Route(
  name: 'countdown',
  path: '/countdown',
  title: 'Countdown',
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

  String withParams(Map<String, String> params) {
    var path = this.path;
    params.forEach((key, value) {
      path = path.replaceAll(':$key', value);
    });

    return path;
  }
}
