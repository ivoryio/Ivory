import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../services/signup_service.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupService signupService = SignupService();

  SignupCubit() : super(const SignupInitial());

  Future<void> setBasicInfo({
    required String email,
    required String firstName,
    required String lastName,
    required String phoneNUmber,
  }) async {
    emit(const SignupLoading());
    emit(BasicInfoComplete(
        email: email,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNUmber));
  }

  Future<void> setPasscode({
    required String phoneNumber,
    required String passcode,
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    emit(const SignupLoading());

    await signupService.createCognitoAccount(
        phoneNumber: phoneNumber,
        email: email,
        firstName: firstName,
        lastName: lastName,
        passcode: passcode);

    emit(SetupPasscode(
        phoneNumber: phoneNumber,
        passcode: passcode,
        email: email,
        firstName: firstName,
        lastName: lastName));
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
