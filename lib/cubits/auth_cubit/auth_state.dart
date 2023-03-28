part of 'auth_cubit.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  final AuthStatus status;

  final User? user;

  const AuthState._({
    this.status = AuthStatus.unknown,
    this.user,
  });

  const AuthState.reset() : this._(status: AuthStatus.unknown);

  const AuthState.authenticated(User user)
      : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  @override
  List<dynamic> get props => [status];
}

class AuthenticationError {
  final String username;
  final String error;

  AuthenticationError({
    required this.username,
    required this.error,
  });
}
