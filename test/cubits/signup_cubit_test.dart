import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:solarisdemo/cubits/signup/signup_cubit.dart';
import 'package:solarisdemo/services/signup_service.dart';

class MockSignupService extends Mock implements CognitoSignupService {}

void main() {
  group('SignupCubit', () {
    late SignupCubit cubit;
    late MockSignupService mockSignupService;

    setUp(() {
      mockSignupService = MockSignupService();
      cubit = SignupCubit();
    });

    test('initial state is SignupInitial', () {
      expect(cubit.state, const SignupInitial());
    });

    test('setBasicInfo emits BasicInfoComplete on success', () async {
      const email = 'test@example.com';
      const firstName = 'John';
      const lastName = 'Doe';
      const phoneNumber = '1234567890';

      expect(cubit.state, const SignupInitial());

      await cubit.setBasicInfo(
        email: email,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        passcode: '',
      );

      expect(
          cubit.state,
          const BasicInfoComplete(
              email: email,
              firstName: firstName,
              lastName: lastName,
              phoneNumber: phoneNumber,
              passcode: ''));
    });

    test('setPasscode emits SetupPasscode on success', () async {
      const passcode = 'pass1234';
      const email = 'test@example.com';
      const firstName = 'John';
      const lastName = 'Doe';
      const phoneNumber = '1234567890';

      expect(cubit.state, const SignupInitial());

      cubit.setConsent(
        phoneNumber: phoneNumber,
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
            phoneNumber: phoneNumber,
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
      const phoneNumber = '1234567890';

      expect(cubit.state, const SignupInitial());

      cubit.confirmToken(
        phoneNumber: phoneNumber,
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
            phoneNumber: phoneNumber,
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
