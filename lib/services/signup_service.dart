
import 'package:amazon_cognito_identity_dart_2/cognito.dart';

import '../config.dart';

class CognitoSignupService {
  CognitoSignupService();

  Future<void> createCognitoAccount({
    required String email,
    required String firstName,
    required String lastName,
    required String passcode,
    required String phoneNumber,
    required String personId,
  }) async {
    try {
      final userPool = CognitoUserPool(
        Config.cognitoUserPoolId,
        Config.cognitoClientId,
      );
      final userAttributes = [
        AttributeArg(name: 'given_name', value: firstName),
        AttributeArg(name: 'family_name', value: lastName),
        AttributeArg(name: 'custom:personId', value: personId),
        const AttributeArg(name: 'custom:accountId', value: ''),
      ];

      await userPool.signUp(
        email,
        passcode,
        userAttributes: userAttributes,
      );
    } catch (e) {
      throw Exception("Failed to create Cognito account");
    }
  }

  Future<void> confirmCognitoAccount({
    required String email,
    required String emailConfirmationCode,
  }) async {
    try {
      final userPool = CognitoUserPool(
        Config.cognitoUserPoolId,
        Config.cognitoClientId,
      );

      CognitoUser user = CognitoUser(email, userPool);

      await user.confirmRegistration(emailConfirmationCode);
    } catch (e) {
      throw Exception("Failed to confirm Cognito account");
    }
  }

  Future<void> addCustomAttribute(
    CognitoUser user,
    CognitoUserAttribute userAttribute,
  ) async {
    try {
      bool isSuccess = await user.updateAttributes([userAttribute]);
      if (!isSuccess) {
        throw Exception("Failed to update user attributes");
      }
    } catch (e) {
      throw Exception("Failed to add custom attribute");
    }
  }
}
