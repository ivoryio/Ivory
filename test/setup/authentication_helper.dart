import 'package:mockito/mockito.dart';
import 'package:solarisdemo/models/auth/auth_type.dart';
import 'package:solarisdemo/models/person_account.dart';
import 'package:solarisdemo/models/person_model.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';

import '../redux/auth/auth_mocks.dart';

class MockPerson extends Mock implements Person {}

class AuthStatePlaceholder {
  static AuthState loggedInState() {
    final user = User(
      session: FakeUserSession(),
      attributes: [],
      cognitoUser: FakeCognitoUser(),
      personId: "personID",
    );
    final person = MockPerson();
    final personAccount = PersonAccount();
    final authUser = AuthenticatedUser(person: person, cognito: user, personAccount: personAccount);

    return AuthenticatedState(authUser, AuthType.withTan);
  }

  static AuthState inOnboardingState() {
    final user = User(
      session: FakeUserSession(),
      attributes: [],
      cognitoUser: FakeCognitoUser(),
      personId: "personID",
    );

    return AuthenticationInitializedState(user, AuthType.onboarding);
  }
}
