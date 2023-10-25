import 'package:solarisdemo/models/auth/auth_type.dart';
import 'package:solarisdemo/models/person_account.dart';
import 'package:solarisdemo/models/person_model.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';

import '../redux/auth/auth_mocks.dart';

class AuthStatePlaceholder {
  static AuthState loggedInState() {
    final user = User(
      session: MockUserSession(),
      attributes: [],
      cognitoUser: MockCognitoUser(),
    );
    final person = Person();
    final personAccount = PersonAccount();
    final authUser = AuthenticatedUser(person: person, cognito: user, personAccount: personAccount);

    return AuthenticatedState(authUser, AuthType.withTan);
  }
}