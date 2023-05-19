part of 'signup_cubit.dart';

abstract class SignupState extends Equatable {
  final bool loading;
  final String? email;
  final String? phoneNumber;
  final String? firstName;
  final String? lastName;
  final String? passcode;
  final String? token;

  const SignupState({
    this.phoneNumber,
    this.loading = false,
    this.email,
    this.firstName,
    this.lastName,
    this.passcode,
    this.token,
  });

  @override
  List<Object> get props => [loading];
}

class SignupInitial extends SignupState {
  const SignupInitial() : super(loading: false);
}

class SignupLoading extends SignupState {
  const SignupLoading() : super(loading: true);
}

class BasicInfoComplete extends SignupState {
  const BasicInfoComplete({
    required String email,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) : super(
            email: email,
            firstName: firstName,
            lastName: lastName,
            phoneNumber: phoneNumber);
}

class SetupPasscode extends SignupState {
  const SetupPasscode({
    required String phoneNumber,
    required String passcode,
    required String email,
    required String firstName,
    required String lastName,
  }) : super(
          phoneNumber: phoneNumber,
          passcode: passcode,
          email: email,
          firstName: firstName,
          lastName: lastName,
        );
}

class ConfirmedUser extends SignupState {
  const ConfirmedUser({
    required String phoneNumber,
    required String passcode,
    required String email,
    required String firstName,
    required String lastName,
  }) : super(
          phoneNumber: phoneNumber,
          passcode: passcode,
          email: email,
          firstName: firstName,
          lastName: lastName,
        );
}
