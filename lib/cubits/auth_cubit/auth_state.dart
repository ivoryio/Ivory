part of 'auth_cubit.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? phoneNumber;

  final bool loading;

  final OauthModel? oauthModel;

  const AuthState._({
    this.status = AuthStatus.unknown,
    this.loading = false,
    this.phoneNumber,
    this.oauthModel,
  });

  const AuthState.loading() : this._(loading: true, status: AuthStatus.unknown);

  const AuthState.setPhoneNumber(String phoneNumber)
      : this._(
          status: AuthStatus.unknown,
          loading: false,
          phoneNumber: phoneNumber,
        );

  const AuthState.authenticated(OauthModel oauthModel)
      : this._(
            status: AuthStatus.authenticated,
            oauthModel: oauthModel,
            loading: false);

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated, loading: false);

  @override
  List<dynamic> get props => [status, phoneNumber];
}
