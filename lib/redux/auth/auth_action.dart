import 'package:solarisdemo/models/user.dart';

class AuthenticateUserCommandAction {
  final String email;
  final String phoneNumber;
  final String password;
  AuthenticateUserCommandAction({
    required this.email,
    required this.phoneNumber,
    required this.password,
  });
}

class ConfirmAuthenticationCommandAction {
  final String tan;
  final void Function() onSuccess;
  ConfirmAuthenticationCommandAction({
    required this.tan,
    required this.onSuccess,
  });
}

class AuthenticatedEventAction {
  final User cognitoUser;
  AuthenticatedEventAction({
    required this.cognitoUser,
  });
}

class AuthenticationConfirmedEventAction {
  final AuthenticatedUser authenticatedUser;

  AuthenticationConfirmedEventAction({
    required this.authenticatedUser,
  });
}

class AuthLoadingEventAction {}

class AuthFailedEventAction {}

class AuthLoggedInAction {
  final User user;
  AuthLoggedInAction(
    this.user,
  );
}
