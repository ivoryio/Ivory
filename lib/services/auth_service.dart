import 'dart:developer';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';

import '../config.dart';
import '../models/user.dart';
import 'person_service.dart';
import '../models/person_model.dart';

class AuthService {
  AuthService();

  Future<User?> login(String username, String passcode) async {
    final userPool = CognitoUserPool(
      Config.cognitoUserPoolId,
      Config.cognitoClientId,
    );

    try {
      final cognitoUser = CognitoUser(username, userPool);
      final authDetails = AuthenticationDetails(
        username: username,
        password: passcode,
      );

      CognitoUserSession? session =
          await cognitoUser.authenticateUser(authDetails);

      List<CognitoUserAttribute>? attributes =
          await cognitoUser.getUserAttributes();

      // debug only
      log("access_token: ${session!.getAccessToken().getJwtToken()}");

      User user = User.fromCognitoUser(
        session: session,
        attributes: attributes!,
        cognitoUser: cognitoUser,
      );

      Person? person = await PersonService(user: user).getPerson();

      if (person == null) {
        throw Exception("Person not found");
      }

      return user;
    } catch (e) {
      log("[AuthService::login] $e");
      rethrow;
    }
  }
}
