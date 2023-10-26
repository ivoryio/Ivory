// class OnboardingSignupAttributes {
//   final String title;
//   final String firstName;
//   final String lastName;
//   final String email;
//   final String password;
//   final bool pushNotificationsAllowed;

//   OnboardingSignupAttributes({
//     required this.title,
//     required this.firstName,
//     required this.lastName,
//     required this.email,
//     required this.password,
//     required this.pushNotificationsAllowed,
//   });
// }

class SubmitOnboardingBasicInfoCommandAction {
  final String title;
  final String firstName;
  final String lastName;

  const SubmitOnboardingBasicInfoCommandAction({
    required this.title,
    required this.firstName,
    required this.lastName,
  });
}

class SubmitOnboardingEmailCommandAction {
  final String email;

  SubmitOnboardingEmailCommandAction({required this.email});
}

class SubmitOnboardingPasswordCommandAction {
  final String password;

  SubmitOnboardingPasswordCommandAction({required this.password});
}

// class SubmitOnboardingSignupCommandAction {
//   final OnboardingSignupAttributes? signupAttributes;

//   SubmitOnboardingSignupCommandAction({this.signupAttributes});
// }

class RequestPushNotificationsPermissionCommandAction {}

class CheckPushNotificationPermissionCommandAction {}

class UpdatedPushNotificationsPermissionEventAction {
  final bool allowed;

  UpdatedPushNotificationsPermissionEventAction({required this.allowed});
}

class OnboardingSignupSuccessEventAction {}

class OnboardingSignupFailedEventAction {}
