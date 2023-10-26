class OnboardingSignupAttributes {
  final String? title;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final bool? pushNotificationsAllowed;
  final String? tsAndCsSignedAt;

  OnboardingSignupAttributes({
    this.title,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.pushNotificationsAllowed,
    this.tsAndCsSignedAt,
  });
}

class SubmitOnboardingSignupCommandAction {
  final OnboardingSignupAttributes signupAttributes;

  SubmitOnboardingSignupCommandAction({required this.signupAttributes});
}

class RequestPushNotificationsPermissionCommandAction {}

class CheckPushNotificationPermissionCommandAction {}

class UpdatedPushNotificationsPermissionEventAction {
  final bool allowed;

  UpdatedPushNotificationsPermissionEventAction({required this.allowed});
}

class OnboardingSignupSuccessEventAction {}

class OnboardingSignupFailedEventAction {}

class OnboardingSignupFailedServerEventAction {}
