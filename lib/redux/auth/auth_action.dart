import 'package:solarisdemo/models/auth/auth_error_type.dart';
import 'package:solarisdemo/models/auth/auth_type.dart';
import 'package:solarisdemo/models/user.dart';

class InitUserAuthenticationCommandAction {
  final String email;
  final String password;
  InitUserAuthenticationCommandAction({
    required this.email,
    required this.password,
  });
}

class LoadCredentialsCommandAction {}

class LogoutUserCommandAction {}

class AuthenticateUserCommandAction {
  final AuthType authType;
  final String tan;
  final User cognitoUser;
  final void Function() onSuccess;
  AuthenticateUserCommandAction({
    required this.authType,
    required this.tan,
    required this.onSuccess,
    required this.cognitoUser,
  });
}

class CredentialsLoadedEventAction {
  final String? email;
  final String? password;
  final String? deviceId;
  CredentialsLoadedEventAction({
    this.email,
    this.password,
    this.deviceId,
  });
}

class AuthenticationInitializedEventAction {
  final AuthType authType;
  final User cognitoUser;
  AuthenticationInitializedEventAction({
    required this.cognitoUser,
    required this.authType,
  });
}

class AuthenticatedEventAction {
  final AuthType authType;
  final AuthenticatedUser authenticatedUser;

  AuthenticatedEventAction({
    required this.authenticatedUser,
    required this.authType,
  });
}

class ResetAuthEventAction {}

class AuthLoadingEventAction {}

class AuthFailedEventAction {
  final AuthErrorType errorType;

  AuthFailedEventAction({
    required this.errorType,
  });
}
