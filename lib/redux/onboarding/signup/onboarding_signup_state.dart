import 'package:equatable/equatable.dart';

abstract class OnboardingSignupState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnboardingSignupSubmittedState extends OnboardingSignupState {
  final String? title;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final bool? notificationsAllowed;

  OnboardingSignupSubmittedState({
    this.title,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.notificationsAllowed,
  });

  @override
  List<Object?> get props => [title, firstName, lastName, email, password, notificationsAllowed];
}
