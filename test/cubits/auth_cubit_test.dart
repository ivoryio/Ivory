import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/services/auth_service.dart';

class MockAuthService extends Mock implements AuthService {}

class MockAuthenticatedUser extends Mock implements AuthenticatedUser {}

void main() {
  group('AuthCubit', () {
    late AuthCubit cubit;
    late MockAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthService();
      cubit = AuthCubit(authService: mockAuthService);
    });

    test('initial state is unauthenticated', () {
      expect(cubit.state, const AuthState.unauthenticated());
    });

    test('login updates state to authenticated', () {
      final mockUser = MockAuthenticatedUser();
      cubit.login(mockUser);

      expect(cubit.state, AuthState.authenticated(mockUser));
    });

    test('logout updates state to unauthenticated', () {
      cubit.logout();

      expect(cubit.state, const AuthState.unauthenticated());
    });

    test('reset updates state to reset', () {
      cubit.reset();

      expect(cubit.state, const AuthState.reset());
    });
  });
}
