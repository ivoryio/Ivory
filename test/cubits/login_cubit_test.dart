import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:solarisdemo/cubits/login_cubit/login_cubit.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/services/auth_service.dart';
import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';
import 'package:solarisdemo/services/person_service.dart';

class MockAuthService extends Mock implements AuthService {
  @override
  Future<User?> login(String username, String password) async {
    try {
      return super.noSuchMethod(
        Invocation.method(#login, [username, password]),
        returnValue: Future.value(
          User(
            email: 'test_email',
            lastName: 'test_last_name',
            session: MockUserSession(),
            attributes: [MockUserAttribute()],
            cognitoUser: MockCognitoUser(),
          ),
        ),
        returnValueForMissingStub: Future.value(
          User(
            email: 'test_email',
            lastName: 'test_last_name',
            session: MockUserSession(),
            attributes: [MockUserAttribute()],
            cognitoUser: MockCognitoUser(),
          ),
        ),
      );
    } catch (e) {
      print(e.toString());
    }
    return User(
      email: 'test_email',
      lastName: 'test_last_name',
      session: MockUserSession(),
      attributes: [MockUserAttribute()],
      cognitoUser: MockCognitoUser(),
    );
  }
}

class MockAuthCubit extends Mock implements AuthCubit {}

class MockPersonService extends Mock implements PersonService {}

class MockUserSession extends Mock implements CognitoUserSession {}

class MockUserAttribute extends Mock implements CognitoUserAttribute {}

class MockCognitoUser extends Mock implements CognitoUser {}

void main() {
  late MockAuthService mockAuthService;
  late MockAuthCubit mockAuthCubit;
  late LoginCubit cubit;

  setUp(() {
    mockAuthService = MockAuthService();
    mockAuthCubit = MockAuthCubit();
    cubit = LoginCubit(
      authCubit: mockAuthCubit,
      authService: mockAuthService,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('LoginCubit', () {
    test('initial state is LoginInitial', () {
      expect(cubit.state, isA<LoginInitial>());
    });

    test(
        'setCredentials updates state to LoginLoadingState then to LoginUserExists on success',
        () async {
      cubit.setCredentials(
        email: 'test_email',
        password: 'test_password',
      );

      mockAuthService.login('test_email', 'test_password');

      expect(cubit.state, isA<LoginLoading>());

      expectLater(cubit.stream, emits(isA<LoginUserExists>()));
    });

    // Add tests for other methods...
  });
}
