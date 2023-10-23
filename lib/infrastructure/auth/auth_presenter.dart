import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/auth/auth_error_type.dart';
import 'package:solarisdemo/models/auth/auth_type.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';

class AuthPresenter {
  static AuthViewModel presentAuth({
    required AuthState authState,
  }) {
    if (authState is AuthCredentialsLoadedState) {
      return AuthCredentialsLoadedViewModel(
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
    } else if (authState is AuthenticationInitializedState) {
      return AuthInitializedViewModel(
        cognitoUser: authState.cognitoUser,
        authType: authState.authType,
      );
    } else if (authState is AuthenticatedState) {
      return AuthenticatedViewModel(
        authenticatedUser: authState.authenticatedUser,
      );
    }
    return AuthInitialViewModel();
  }
}

abstract class AuthViewModel extends Equatable {
  final User? cognitoUser;
  final AuthenticatedUser? authenticatedUser;
  final String? tan;
  final AuthType? authType;
  final AuthErrorType? errorType;
  final String? email;
  final String? password;
  final String? deviceId;

  const AuthViewModel({
    this.cognitoUser,
    this.authenticatedUser,
    this.tan,
    this.errorType,
    this.authType,
    this.email,
    this.password,
    this.deviceId,
  });

  @override
  List<Object?> get props => [cognitoUser, authenticatedUser, tan, authType];
}

class AuthInitialViewModel extends AuthViewModel {}

class AuthCredentialsLoadedViewModel extends AuthViewModel {
  const AuthCredentialsLoadedViewModel({
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

class AuthInitializedViewModel extends AuthViewModel {
  const AuthInitializedViewModel({
    required AuthType authType,
    required User cognitoUser,
  }) : super(cognitoUser: cognitoUser, authType: authType);

  @override
  List<Object?> get props => [cognitoUser, authType];
}

class AuthenticatedViewModel extends AuthViewModel {
  const AuthenticatedViewModel({
    required AuthenticatedUser authenticatedUser,
  }) : super(authenticatedUser: authenticatedUser);

  @override
  List<Object?> get props => [authenticatedUser];
}
