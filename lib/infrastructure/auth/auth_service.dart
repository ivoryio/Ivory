import 'dart:developer';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:equatable/equatable.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/models/auth/auth_error_type.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/services/api_service.dart';

class AuthService extends ApiService {
  AuthService({super.user});

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

      if (ClientConfig.getFeatureFlags().simplifiedLogin) {
        // final data = await post('/login', authNeeded: false, body: {
        //   'email': Config.apiUser,
        //   'password': Config.apiPassword,
        // });
        final data = {'token': 'accessToken'};
        final token = data['token'] as String;

        user.apiKey = token;

        // debug only
        log('user.apiKey: ${user.apiKey}');
      }

      return LoginSuccessResponse(user: user);
    } catch (e) {
      //additional error handling needed here
      return AuthServiceErrorResponse(errorType: AuthErrorType.invalidCredentials);
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
  final AuthErrorType errorType;

  AuthServiceErrorResponse({this.errorType = AuthErrorType.unknown});

  @override
  List<Object?> get props => [];
}
