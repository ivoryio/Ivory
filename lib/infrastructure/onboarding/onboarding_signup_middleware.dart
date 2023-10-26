import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/notifications/push_notification_service.dart';
import 'package:solarisdemo/infrastructure/onboarding/onboarding_signup_service.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_action.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_state.dart';

class OnboardingSignupMiddleware extends MiddlewareClass<AppState> {
  final PushNotificationService _pushNotificationService;
  final OnboardingSignupService _onboardingSignupService;

  OnboardingSignupMiddleware(
    this._pushNotificationService,
    this._onboardingSignupService,
  );

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is RequestPushNotificationsPermissionCommandAction) {
      await _pushNotificationService.init(store);
      final hasPermission = await _pushNotificationService.hasPermission();

      store.dispatch(UpdatedPushNotificationsPermissionEventAction(allowed: hasPermission));
    }

    if (action is CheckPushNotificationPermissionCommandAction) {
      final hasPermission = await _pushNotificationService.hasPermission();

      store.dispatch(UpdatedPushNotificationsPermissionEventAction(allowed: hasPermission));
    }

    if (action is SubmitOnboardingEmailCommandAction) {
      final currentState = store.state.onboardingSignupState;

      final response = await _onboardingSignupService.createPerson(
        title: currentState.title!,
        email: action.email,
        firstName: currentState.firstName!,
        lastName: currentState.lastName!,
      );

      if (response is CreatePersonSuccesResponse) {
        store.dispatch(OnboardingSignupSuccessEventAction());
      } else {
        store.dispatch(OnboardingSignupFailedEventAction());
      }
    }
  }
}
