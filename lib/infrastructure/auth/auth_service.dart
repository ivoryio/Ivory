import 'dart:developer';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:equatable/equatable.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/models/auth/auth_service_error_type.dart';
import 'package:solarisdemo/models/user.dart';

class AuthService {
  AuthService();

  Future<AuthServiceResponse> login(String username, String passcode) async {
    try {
      final userPool = CognitoUserPool(
        Config.cognitoUserPoolId,
        Config.cognitoClientId,
      );

      final cognitoUser = CognitoUser(username, userPool);
      final authDetails = AuthenticationDetails(
        username: username,
        password: passcode,
      );
      CognitoUserSession? session = await cognitoUser.authenticateUser(authDetails);

      List<CognitoUserAttribute>? attributes = await cognitoUser.getUserAttributes();

      // debug only
      log("access_token: ${session!.getAccessToken().getJwtToken()}");

      User user = User.fromCognitoUser(
        session: session,
        attributes: attributes!,
        cognitoUser: cognitoUser,
      );

      return LoginSuccessResponse(user: user);
    } catch (e) {
      return AuthServiceErrorResponse(errorType: AuthServiceErrorType.invalidCredentials);
    }
  }
}

abstract class AuthServiceResponse extends Equatable {}

class LoginSuccessResponse extends AuthServiceResponse {
  final User user;

  LoginSuccessResponse({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthServiceErrorResponse extends AuthServiceResponse {
  final AuthServiceErrorType errorType;

  AuthServiceErrorResponse({this.errorType = AuthServiceErrorType.unknown});

  @override
  List<Object?> get props => [];
}
