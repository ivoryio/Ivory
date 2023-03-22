part of 'auth_cubit.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? loginInputEmail;
  final String? loginInputPhoneNumber;
  final AuthenticationError? authenticationError;

  final OauthModel? oauthModel;
  final User? user;

  const AuthState._({
    this.status = AuthStatus.unknown,
    this.loginInputPhoneNumber,
    this.loginInputEmail,
    this.oauthModel,
    this.authenticationError,
    this.user,
  });

  const AuthState.reset() : this._(status: AuthStatus.unknown);

  AuthState.setAuthenticationError(String username, String error)
      : this._(
            authenticationError: AuthenticationError(
              username: username,
              error: error,
            ),
            status: AuthStatus.unknown);

  const AuthState.setPhoneNumber(String phoneNumber)
      : this._(
          status: AuthStatus.unknown,
          loginInputPhoneNumber: phoneNumber,
          loginInputEmail: null,
        );

  const AuthState.setEmail(String email)
      : this._(
          status: AuthStatus.unknown,
          loginInputEmail: email,
          loginInputPhoneNumber: null,
        );

  const AuthState.authenticated(User user)
      : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  @override
  List<dynamic> get props =>
      [status, loginInputPhoneNumber, loginInputEmail, authenticationError];
}

class AuthenticationError {
  final String username;
  final String error;

  AuthenticationError({
    required this.username,
    required this.error,
  });
}
