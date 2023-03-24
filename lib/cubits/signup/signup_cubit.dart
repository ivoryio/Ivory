import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../services/signup_service.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupService signupService = SignupService();

  SignupCubit() : super(SignupInitial());

  Future<void> setBasicInfo({
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    emit(const SignupLoading());
    emit(BasicInfoComplete(
        email: email, firstName: firstName, lastName: lastName));
  }

  Future<void> setPasscode({
    required String passcode,
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    emit(const SignupLoading());

    await signupService.signup(
        email: email,
        firstName: firstName,
        lastName: lastName,
        passcode: passcode);

    emit(SetupPasscode(
        passcode: passcode,
        email: email,
        firstName: firstName,
        lastName: lastName));
  }

  Future<void> confirmToken({
    required String token,
    required String passcode,
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    emit(const SignupLoading());
    await signupService.confirmSignup(email: email, token: token);

    emit(ConfirmedUser(
        passcode: passcode,
        email: email,
        firstName: firstName,
        lastName: lastName));
  }
}
