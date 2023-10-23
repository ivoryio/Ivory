import 'package:amazon_cognito_identity_dart_2/cognito.dart';

import 'person_account.dart';
import 'person_model.dart';

class User {
  late String? email;
  late String? personId;
  late String? lastName;
  late String? firstName;
  late String? accountId;

  final CognitoUser cognitoUser;
  late CognitoUserSession session;
  final List<CognitoUserAttribute> attributes;

  User({
    required this.session,
    required this.attributes,
    required this.cognitoUser,
    this.email,
    this.lastName,
    this.personId,
    this.firstName,
    this.accountId,
  });

  factory User.fromCognitoUser({
    required CognitoUser cognitoUser,
    required CognitoUserSession session,
    required List<CognitoUserAttribute> attributes,
  }) {
    User user = User(
      session: session,
      attributes: attributes,
      cognitoUser: cognitoUser,
    );

    for (CognitoUserAttribute attribute in attributes) {
      switch (attribute.getName()) {
        case 'email':
          user.email = attribute.getValue();
          break;
        case 'custom:personId':
          user.personId = attribute.getValue();
          break;
        case 'custom:accountId':
          user.accountId = attribute.getValue();
          break;
        case 'family_name':
          user.lastName = attribute.getValue();
          break;
        case 'given_name':
          user.firstName = attribute.getValue();
          break;
      }
    }

    return user;
  }
}

class AuthenticatedUser {
  final User cognito;
  final Person person;
  final PersonAccount personAccount;

  AuthenticatedUser({
    required this.person,
    required this.cognito,
    required this.personAccount,
  });
}

class CacheCredentials {
  String? email;
  String? password;
  String? deviceId;

  CacheCredentials({
    required this.email,
    required this.password,
    required this.deviceId,
  });
}