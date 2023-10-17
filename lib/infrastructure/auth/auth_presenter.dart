import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/auth/auth_loading_type.dart';
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
      );
    } else if (authState is AuthLoadingState) {
      return AuthLoadingViewModel(
        authState.loadingType,
      );
    } else if (authState is AuthErrorState) {
      return AuthErrorViewModel();
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
  final AuthLoadingType? loadingType;
  final String? email;
  final String? password;

  const AuthViewModel({
    this.cognitoUser,
    this.authenticatedUser,
    this.tan,
    this.loadingType,
    this.email,
    this.password,
  });

  @override
  List<Object?> get props => [cognitoUser, authenticatedUser, tan];
}

class AuthInitialViewModel extends AuthViewModel {
  const AuthInitialViewModel({
    String? email,
    String? password,
  }) : super(email: email, password: password);
}

class AuthLoadingViewModel extends AuthViewModel {
  const AuthLoadingViewModel(
    AuthLoadingType loadingType,
  ) : super(loadingType: loadingType);
}

class AuthErrorViewModel extends AuthViewModel {}

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
