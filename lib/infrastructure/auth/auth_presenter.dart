import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/auth/auth_error_type.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';

class AuthPresenter {
  static AuthViewModel presentAuth({
    required AuthState authState,
  }) {
    if (authState is AuthInitialState) {
      return AuthInitialViewModel(
        email: authState.email ?? authState.email,
        password: authState.password ?? authState.password,
        deviceId: authState.deviceId ?? authState.deviceId,
      );
    } else if (authState is AuthLoadingState) {
      return AuthLoadingViewModel(
      );
    } else if (authState is AuthErrorState) {
      return AuthErrorViewModel(
        authState.errorType,
      );
    } else if (authState is AuthenticatedWithoutBoundDeviceState) {
      return AuthenticatedWithoutBoundDeviceViewModel(
        cognitoUser: authState.cognitoUser,
      );
    } else if (authState is AuthenticatedWithBoundDeviceState) {
      return AuthenticatedWithBoundDeviceViewModel(
        cognitoUser: authState.cognitoUser,
      );
    } else if (authState is AuthenticatedAndConfirmedState) {
      return AuthenticatedAndConfirmedViewModel(
        authenticatedUser: authState.authenticatedUser,
      );
    }
    return const AuthInitialViewModel();
  }
}

abstract class AuthViewModel extends Equatable {
  final User? cognitoUser;
  final AuthenticatedUser? authenticatedUser;
  final String? tan;
  final AuthErrorType? errorType;
  final String? email;
  final String? password;
  final String? deviceId;

  const AuthViewModel({
    this.cognitoUser,
    this.authenticatedUser,
    this.tan,
    this.errorType,
    this.email,
    this.password,
    this.deviceId,
  });

  @override
  List<Object?> get props => [cognitoUser, authenticatedUser, tan];
}

class AuthInitialViewModel extends AuthViewModel {
  const AuthInitialViewModel({
    String? email,
    String? password,
    String? deviceId,
  }) : super(email: email, password: password, deviceId: deviceId);
}

class AuthLoadingViewModel extends AuthViewModel {}

class AuthErrorViewModel extends AuthViewModel {
  const AuthErrorViewModel(
    AuthErrorType errorType,
  ) : super(errorType: errorType);
}

class AuthenticatedWithoutBoundDeviceViewModel extends AuthViewModel {
  const AuthenticatedWithoutBoundDeviceViewModel({
    required User cognitoUser,
  }) : super(cognitoUser: cognitoUser);

  @override
  List<Object?> get props => [cognitoUser];
}

class AuthenticatedWithBoundDeviceViewModel extends AuthViewModel {
  const AuthenticatedWithBoundDeviceViewModel({
    required User cognitoUser,
  }) : super(cognitoUser: cognitoUser);

  @override
  List<Object?> get props => [cognitoUser];
}

class AuthenticatedAndConfirmedViewModel extends AuthViewModel {
  const AuthenticatedAndConfirmedViewModel({
    required AuthenticatedUser authenticatedUser,
  }) : super(authenticatedUser: authenticatedUser);

  @override
  List<Object?> get props => [authenticatedUser];
}
