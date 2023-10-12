import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/user.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthErrorState extends AuthState {}

class AuthenticatedState extends AuthState {
  final User cognitoUser;

  AuthenticatedState(this.cognitoUser);

  @override
  List<Object?> get props => [cognitoUser];
}

class AuthenticatedAndConfirmedState extends AuthState {
  final AuthenticatedUser user;

  AuthenticatedAndConfirmedState(this.user);

  @override
  List<Object?> get props => [user];
}
