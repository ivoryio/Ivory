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

class RequestPushNotificationsPermissionCommandAction {}

class CheckPushNotificationPermissionCommandAction {}

class UpdatedPushNotificationsPermissionEventAction {
  final bool allowed;

  UpdatedPushNotificationsPermissionEventAction({required this.allowed});
}
