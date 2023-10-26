import 'package:equatable/equatable.dart';

class OnboardingSignupSubmittedState extends Equatable {
  final String? title;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final bool? notificationsAllowed;
  final String? tsAndCsSignedAt;

  OnboardingSignupSubmittedState({
    this.title,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.notificationsAllowed,
    this.tsAndCsSignedAt,
  });

  @override
  List<Object?> get props => [title, firstName, lastName, email, password, notificationsAllowed, tsAndCsSignedAt];
}
