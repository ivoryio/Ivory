import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:solarisdemo/services/auth_service.dart';
import 'package:solarisdemo/services/device_service.dart';
import 'package:solarisdemo/services/person_service.dart';

import '../../models/device_activity.dart';
import '../../models/device_consent.dart';
import '../../models/person_model.dart';
import '../../models/user.dart';
import '../../services/signup_service.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  CognitoSignupService signupService = CognitoSignupService();
  PersonService personService = PersonService();
  AuthService authService = AuthService();

  SignupCubit() : super(const SignupInitial());

  // 1. Create Solaris person and account, create Cognito User and linking the two
  Future<void> setBasicInfo({
    required String email,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String passcode,
  }) async {
    emit(const SignupLoading());

    try {
      CreatePersonResponse? createPersonResponse =
          await personService.createPerson(CreatePersonReqBody(
        email: email,
        firstName: firstName,
        lastName: lastName,
        mobileNumber: phoneNumber,
      ));

      if (createPersonResponse == null) {
        throw Exception("Failed to create person");
      }
      await signupService.createCognitoAccount(
        phoneNumber: phoneNumber,
        email: email,
        firstName: firstName,
        lastName: lastName,
        passcode: passcode,
        accountId: createPersonResponse.accountId,
        personId: createPersonResponse.personId,
      );
      emit(SignupBasicInfoComplete(
        personId: createPersonResponse.personId,
        email: email,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        passcode: passcode,
      ));
    } catch (e) {
      emit(SignupError(
        message: e.toString(),
      ));
    }
  }

  //2. Ask GDPR consent
  Future<void> setGdprConsent({
    required String email,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String passcode,
    required String personId,
  }) async {
    emit(const SignupLoading());
    try {
      emit(SignupGdprConsentComplete(
        personId: personId,
        email: email,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        passcode: passcode,
      ));
    } catch (e) {
      emit(SignupError(
        message: e.toString(),
      ));
    }
  }

  // 3. Confirm email address (Cognito account), create consent, create activity, create mobile number to confirm
  Future<void> confirmEmail({
    required String phoneNumber,
    required String passcode,
    required String email,
    required String firstName,
    required String lastName,
    required String personId,
    required String emailConfirmationCode,
  }) async {
    emit(const SignupLoading());
    try {
      await signupService.confirmCognitoAccount(
          email: email, emailConfirmationCode: emailConfirmationCode);

      User? user = await authService.login(email, passcode);

      if (user == null) {
        throw Exception("Failed to login");
      }

      CreateDeviceConsentResponse? createdConsent =
          await DeviceService(user: user).createDeviceConsent();

      if (createdConsent != null) {
        await DeviceUtilService.saveDeviceConsentId(createdConsent.id);
      }

      await DeviceService().createDeviceActivity(
          user.personId!, DeviceActivityType.CONSENT_PROVIDED);

      

      emit(SignupEmailConfirmed(
        user: user,
        phoneNumber: phoneNumber,
        passcode: passcode,
        email: email,
        firstName: firstName,
        lastName: lastName,
      ));
    } catch (e) {
      emit(SignupError(
        message: e.toString(),
      ));
    }
  }

  // 4. Confirm mobile number and create binding
  Future<void> confirmPhoneNumber({
    required User user,
    required String phoneNumber,
    required String mobileNumberConfirmationCode,
  }) async {
    emit(const SignupLoading());

    try {
      //confirm number and create binding

      // await personService.createMobileNumber(CreateDeviceReqBody(
      //   personId: personId,
      //   number: phoneNumber,
      //   deviceData: 'asdf',
      // ));

      emit(const SignupMobileNumberConfirmed());
    } catch (e) {
      emit(SignupError(
        message: e.toString(),
      ));
    }
  }
}
