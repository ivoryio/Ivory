import 'dart:developer';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService {
  BuildContext context;
  AuthService({required this.context});

  Future<User?> login(String username, String passcode) async {
    final userPool = CognitoUserPool(
      'eu-west-1_Z7d8UgNEM',
      '2iccudrlh0j2m4pd3tii9d8p13',
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

      return User(session: session!, attributes: attributes!);
    } catch (e) {
      log("[AuthService::login] $e");
      rethrow;
    }
  }
}

class User {
  final CognitoUserSession session;
  final List<CognitoUserAttribute> attributes;

  User({required this.session, required this.attributes});
}
