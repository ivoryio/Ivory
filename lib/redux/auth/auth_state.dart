import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/auth/auth_error_type.dart';
import 'package:solarisdemo/models/auth/auth_loading_type.dart';
import 'package:solarisdemo/models/user.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitialState extends AuthState {
  final String? email;
  final String? password;
  final String? deviceId;

  AuthInitialState({
    this.email,
    this.password,
    this.deviceId,
  });
}

class AuthLoadingState extends AuthState {
  final AuthLoadingType loadingType;

  AuthLoadingState(this.loadingType);

  @override
  List<Object?> get props => [loadingType];
}

class AuthTanConfirmState extends AuthState {}

class AuthErrorState extends AuthState {
  final AuthErrorType errorType;

  AuthErrorState(this.errorType);
}

class AuthenticatedWithoutBoundDeviceState extends AuthState {
  final User cognitoUser;

  AuthenticatedWithoutBoundDeviceState(this.cognitoUser);

  @override
  List<Object?> get props => [cognitoUser];
}

class AuthenticatedWithBoundDeviceState extends AuthState {
  final User cognitoUser;

  AuthenticatedWithBoundDeviceState(this.cognitoUser);

  @override
  List<Object?> get props => [cognitoUser];
}

class AuthenticatedAndConfirmedState extends AuthState {
  final AuthenticatedUser authenticatedUser;

  AuthenticatedAndConfirmedState(this.authenticatedUser);

  @override
  List<Object?> get props => [authenticatedUser];
}
