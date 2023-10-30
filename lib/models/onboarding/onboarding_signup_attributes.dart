import 'package:equatable/equatable.dart';

class OnboardingSignupAttributes extends Equatable {
  final String? title;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final bool? notificationsAllowed;

  const OnboardingSignupAttributes({
    this.title,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.notificationsAllowed,
  });

  bool get hasBasicInfo => title != null && firstName != null && lastName != null;

  OnboardingSignupAttributes copyWith({
    String? title,
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    bool? notificationsAllowed,
    String? tsAndCsSignedAt,
  }) {
    return OnboardingSignupAttributes(
      title: title ?? this.title,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      notificationsAllowed: notificationsAllowed ?? this.notificationsAllowed,
    );
  }

  @override
  List<Object?> get props => [title, firstName, lastName, email, password, notificationsAllowed];
}
