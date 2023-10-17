import 'package:solarisdemo/models/auth/auth_error_type.dart';
import 'package:solarisdemo/models/auth/auth_loading_type.dart';
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

class LoadCredentialsCommandAction {}

class LogoutUserCommandAction {}

class ConfirmTanAuthenticationCommandAction {
  final String tan;
  final User cognitoUser;
  final void Function() onSuccess;
  ConfirmTanAuthenticationCommandAction({
    required this.tan,
    required this.onSuccess,
    required this.cognitoUser,
  });
}

class ConfirmBiometricAuthenticationCommandAction {
  final User cognitoUser;
  final void Function() onSuccess;
  ConfirmBiometricAuthenticationCommandAction({
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

class AuthenticatedWithoutBoundDeviceEventAction {
  final User cognitoUser;
  AuthenticatedWithoutBoundDeviceEventAction({
    required this.cognitoUser,
  });
}

class AuthenticatedWithBoundDeviceEventAction {
  final User cognitoUser;
  AuthenticatedWithBoundDeviceEventAction({
    required this.cognitoUser,
  });
}

class AuthenticationConfirmedEventAction {
  final AuthenticatedUser authenticatedUser;

  AuthenticationConfirmedEventAction({
    required this.authenticatedUser,
  });
}

class LoggedOutEventAction {}

class AuthLoadingEventAction {
  final AuthLoadingType loadingType;

  AuthLoadingEventAction({
    required this.loadingType,
  });
}

class AuthFailedEventAction {
  final AuthErrorType errorType;

  AuthFailedEventAction({
    required this.errorType,
  });
}

class AuthLoggedInAction {
  final User user;
  AuthLoggedInAction(
    this.user,
  );
}
