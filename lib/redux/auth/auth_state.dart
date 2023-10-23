import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/auth/auth_error_type.dart';
import 'package:solarisdemo/models/auth/auth_type.dart';
import 'package:solarisdemo/models/user.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthCredentialsLoadedState extends AuthState {
  final String? email;
  final String? password;
  final String? deviceId;

  AuthCredentialsLoadedState({
    this.email,
    this.password,
    this.deviceId,
  });
}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthTanConfirmState extends AuthState {}

class AuthErrorState extends AuthState {
  final AuthErrorType errorType;

  AuthErrorState(this.errorType);
}

class AuthenticationInitializedState extends AuthState {
  final AuthType authType;
  final User cognitoUser;

  AuthenticationInitializedState(
    this.cognitoUser,
    this.authType,
  );

  @override
  List<Object?> get props => [cognitoUser];
}

class AuthenticatedState extends AuthState {
  final AuthType authType;
  final AuthenticatedUser authenticatedUser;

  AuthenticatedState(this.authenticatedUser, this.authType);

  @override
  List<Object?> get props => [authenticatedUser];
}
