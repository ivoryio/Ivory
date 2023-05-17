import 'package:solarisdemo/models/user.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';

class MockCognitoUser extends Mock implements CognitoUser {}

class MockCognitoUserSession extends Mock implements CognitoUserSession {}

class MockCognitoUserAttribute extends Mock implements CognitoUserAttribute {}

void main() {
  group('User', () {
    test('fromCognitoUser', () {
      var cognitoUser = MockCognitoUser();
      var session = MockCognitoUserSession();
      var emailAttribute = MockCognitoUserAttribute();
      var personIdAttribute = MockCognitoUserAttribute();
      var accountIdAttribute = MockCognitoUserAttribute();
      var familyNameAttribute = MockCognitoUserAttribute();
      var givenNameAttribute = MockCognitoUserAttribute();

      when(emailAttribute.getName()).thenReturn('email');
      when(emailAttribute.getValue()).thenReturn('test@example.com');
      when(personIdAttribute.getName()).thenReturn('custom:personId');
      when(personIdAttribute.getValue()).thenReturn('1');
      when(accountIdAttribute.getName()).thenReturn('custom:accountId');
      when(accountIdAttribute.getValue()).thenReturn('2');
      when(familyNameAttribute.getName()).thenReturn('family_name');
      when(familyNameAttribute.getValue()).thenReturn('Doe');
      when(givenNameAttribute.getName()).thenReturn('given_name');
      when(givenNameAttribute.getValue()).thenReturn('John');

      var attributes = <CognitoUserAttribute>[
        emailAttribute,
        personIdAttribute,
        accountIdAttribute,
        familyNameAttribute,
        givenNameAttribute,
      ];

      var user = User.fromCognitoUser(
          cognitoUser: cognitoUser, session: session, attributes: attributes);

      expect(user.email, 'test@example.com');
      expect(user.personId, '1');
      expect(user.accountId, '2');
      expect(user.lastName, 'Doe');
      expect(user.firstName, 'John');
    });
  });
}
