import 'dart:developer';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService {
  BuildContext context;
  AuthService({required this.context});

  Future<User?> login(String username, String passcode) async {
    final userPool = CognitoUserPool(
      'eu-west-1_nWKwWD6Jf',
      '5g6agaurmihi1g3u8f6sa21l20',
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

      return User(session: session!, attributes: attributes!);
    } catch (e) {
      log("[AuthService::login] $e");
      rethrow;
    }
  }

  signupWithEmail({
    required String firstName,
    required String lastName,
    required String emailAddress,
  }) {}
}

class User {
  final CognitoUserSession session;
  final List<CognitoUserAttribute> attributes;

  User({required this.session, required this.attributes});
}
