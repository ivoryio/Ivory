import 'dart:developer';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';

import '../config.dart';
import '../models/user.dart';

class AuthService {
  BuildContext context;
  AuthService({required this.context});

  Future<User?> login(String username, String passcode) async {
    final userPool = CognitoUserPool(
      Config.cognitoUserPoolId,
      Config.cognitoClientId,
    );

    try {
      // debug only - simulate network delay
      await Future.delayed(const Duration(seconds: 2));

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

      return User.fromCognitoUser(session, attributes!);
    } catch (e) {
      log("[AuthService::login] $e");
      rethrow;
    }
  }
}
