import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:solarisdemo/services/person_service.dart';

import '../../models/person_model.dart';
import '../../services/signup_service.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  CognitoSignupService signupService = CognitoSignupService();
  PersonService personService = PersonService();

  SignupCubit() : super(const SignupInitial());

  // 1. Create Solaris person and account, linking with Congito user
  Future<void> setBasicInfo({
    required String email,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String passcode,
  }) async {
    emit(const SignupLoading());

    CreatePersonResponse createPersonResponse =
        await personService.createPerson(CreatePersonReqBody(
      email: email,
      firstName: firstName,
      lastName: lastName,
      mobileNumber: phoneNumber,
    ));

    await signupService.createCognitoAccount(
      phoneNumber: phoneNumber,
      email: email,
      firstName: firstName,
      lastName: lastName,
      passcode: passcode,
      accountId: createPersonResponse.accountId,
      personId: createPersonResponse.personId,
    );

    emit(BasicInfoComplete(
      email: email,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      passcode: passcode,
    ));
  }

  // 2. Create Solaris Device and create device binding
  Future<void> setConsent({
    required String phoneNumber,
    required String passcode,
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    emit(const SignupLoading());

    await personService.createPerson(CreatePersonReqBody(
      email: email,
      firstName: firstName,
      lastName: lastName,
      mobileNumber: phoneNumber,
    ));

    emit(SetupPasscode(
      phoneNumber: phoneNumber,
      passcode: passcode,
      email: email,
      firstName: firstName,
      lastName: lastName,
    ));
  }

  Future<void> confirmToken({
    required String phoneNumber,
    required String token,
    required String passcode,
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    emit(const SignupLoading());
    await signupService.confirmCognitoAccount(email: email, token: token);

    emit(ConfirmedUser(
        phoneNumber: phoneNumber,
        passcode: passcode,
        email: email,
        firstName: firstName,
        lastName: lastName));
  }
}
