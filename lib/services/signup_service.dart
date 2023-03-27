import 'dart:developer';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';

import '../config.dart';

class SignupService {
  SignupService();

  Future<void> signup({
    required String email,
    required String firstName,
    required String lastName,
    required String passcode,
  }) async {
    try {
      final userPool = CognitoUserPool(
        Config.cognitoUserPoolId,
        Config.cognitoClientId,
      );
      final userAttributes = [
        AttributeArg(name: 'given_name', value: firstName),
        AttributeArg(name: 'family_name', value: lastName),
      ];

      CognitoUserPoolData? poolData = await userPool.signUp(
        email,
        passcode,
        userAttributes: userAttributes,
      );

      inspect(poolData);
    } catch (e) {
      inspect(e);
    }
  }

  Future<void> confirmSignup({
    required String email,
    required String token,
  }) async {
    try {
      final userPool = CognitoUserPool(
        Config.cognitoUserPoolId,
        Config.cognitoClientId,
      );

      CognitoUser user = CognitoUser(email, userPool);

      bool confirmed = await user.confirmRegistration(token);

      print("Confirmed: $confirmed");
    } catch (e) {
      inspect(e);
    }
  }
}
