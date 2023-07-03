import 'dart:developer';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:solarisdemo/services/auth_service.dart';
import 'package:solarisdemo/services/device_service.dart';
import 'package:solarisdemo/services/person_service.dart';

import '../../models/device.dart';
import '../../models/device_activity.dart';
import '../../models/device_consent.dart';
import '../../models/person_account.dart';
import '../../models/person_model.dart';
import '../../models/user.dart';
import '../../services/signup_service.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  CognitoSignupService signupService = CognitoSignupService();
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
      PersonService personService =
          PersonService(); //personService without auth

      CreatePersonResponse? createPersonResponse =
          await personService.createPerson(CreatePersonReqBody(
        email: email,
        firstName: firstName,
        lastName: lastName,
        mobileNumber: "+15550101",
      ));

      if (createPersonResponse == null) {
        throw Exception("Failed to create person");
      }

      log(createPersonResponse.personId);

      await signupService.createCognitoAccount(
        phoneNumber: phoneNumber,
        email: email,
        firstName: firstName,
        lastName: lastName,
        passcode: passcode,
        // accountId: createPersonResponse.accountId,
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

      PersonService personService = PersonService(user: user);

      CreateDeviceConsentResponse? createdConsent =
          await DeviceService(user: user).createDeviceConsent();

      if (createdConsent != null) {
        await DeviceUtilService.saveDeviceConsentId(createdConsent.id);
      }

      await DeviceService(user: user)
          .createDeviceActivity(DeviceActivityType.CONSENT_PROVIDED);

      String? deviceFingerPrint =
          await DeviceUtilService.getDeviceFingerprint(createdConsent!.id);
      if (deviceFingerPrint == null) {
        throw Exception("Device fingerprint not found");
      }

      //create mobile number
      await personService.createMobileNumber(CreateDeviceReqBody(
        deviceData: deviceFingerPrint,
      ));

      //create device binding
      // DeviceService deviceService = DeviceService(user: user);

      // await deviceService.createDeviceBinding(user.personId!);

      //verify device binding signature
      // await deviceService.verifyDeviceBindingSignature(
      //     '212212'); // verify device with static TAN - To be refactored

      //create tax identification
      CreateTaxIdentificationResponse? taxIdentificationResponse =
          await personService.createTaxIdentification(
        CreateTaxIdentificationReqBody(
          number: "48954371207",
          country: "DE",
          primary: true,
        ),
      );
      if (taxIdentificationResponse == null) {
        throw Exception("Failed to create tax identification");
      }

      //create kyc
      CreateKycResponse? kycResponse = await personService.createKyc(
        CreateKycReqBody(
          method: "idnow",
          deviceData: deviceFingerPrint,
        ),
      );
      if (kycResponse == null) {
        throw Exception("Failed to create kyc");
      }

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

  Future<void> createAccount(User user) async {
    emit(const SignupLoading());

    PersonService personService = PersonService(user: user);

    //create bank account and update cognitoUser with newly created accountId
    CreateAccountResponse? createAccountResponse =
        await personService.createAccount();

    if (createAccountResponse == null) {
      throw Exception("Failed to create account");
    }
    String accountId = createAccountResponse.accountId;
    await signupService.addCustomAttribute(
      user.cognitoUser,
      CognitoUserAttribute(
        name: "custom:accountId",
        value: accountId,
      ),
    );
  }
}
