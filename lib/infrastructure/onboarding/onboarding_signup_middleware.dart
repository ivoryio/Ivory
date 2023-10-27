import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/notifications/push_notification_service.dart';
import 'package:solarisdemo/infrastructure/onboarding/onboarding_signup_service.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_action.dart';

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
  }
}
