import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:solarisdemo/cubits/signup/signup_cubit.dart';
import 'package:solarisdemo/services/signup_service.dart';

class MockSignupService extends Mock implements SignupService {}

void main() {
  group('SignupCubit', () {
    late SignupCubit cubit;

    setUp(() {
      cubit = SignupCubit();
    });

    test('initial state is SignupInitial', () {
      expect(cubit.state, const SignupInitial());
    });

    test('setBasicInfo emits BasicInfoComplete on success', () async {
      const email = 'test@example.com';
      const firstName = 'John';
      const lastName = 'Doe';

      expect(cubit.state, const SignupInitial());

      await cubit.setBasicInfo(
          email: email, firstName: firstName, lastName: lastName);

      expect(
          cubit.state,
          const BasicInfoComplete(
              email: email, firstName: firstName, lastName: lastName));
    });

    test('setPasscode emits SetupPasscode on success', () async {
      const passcode = 'pass1234';
      const email = 'test@example.com';
      const firstName = 'John';
      const lastName = 'Doe';

      expect(cubit.state, const SignupInitial());

      cubit.setPasscode(
        passcode: passcode,
        email: email,
        firstName: firstName,
        lastName: lastName,
      );

      expect(cubit.state, const SignupLoading());

      await expectLater(
        cubit.stream,
        emits(
          const SetupPasscode(
            passcode: passcode,
            email: email,
            firstName: firstName,
            lastName: lastName,
          ),
        ),
      );
    });

    test('confirmToken emits ConfirmedUser on success', () async {
      const token = 'token1234';
      const passcode = 'pass1234';
      const email = 'test@example.com';
      const firstName = 'John';
      const lastName = 'Doe';

      expect(cubit.state, const SignupInitial());

      cubit.confirmToken(
        token: token,
        passcode: passcode,
        email: email,
        firstName: firstName,
        lastName: lastName,
      );

      expect(cubit.state, const SignupLoading());

      await expectLater(
        cubit.stream,
        emits(
          const ConfirmedUser(
            passcode: passcode,
            email: email,
            firstName: firstName,
            lastName: lastName,
          ),
        ),
      );
    });
  });
}
