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

    if (action is SubmitOnboardingSignupCommandAction) {
      try {
        late final response;

        if (action.signupAttributes.title != null &&
            action.signupAttributes.email != null &&
            action.signupAttributes.firstName != null &&
            action.signupAttributes.lastName != null &&
            action.signupAttributes.pushNotificationsAllowed != null &&
            action.signupAttributes.tsAndCsSignedAt != null) {
          response = await _onboardingSignupService.createPerson(
            title: action.signupAttributes.title!,
            email: action.signupAttributes.email!,
            firstName: action.signupAttributes.firstName!,
            lastName: action.signupAttributes.lastName!,
            pushNotificationsAllowed: action.signupAttributes.pushNotificationsAllowed!,
            tsAndCsSignedAt: action.signupAttributes.tsAndCsSignedAt!,
          );
        }

        if (response is CreatePersonSuccesResponse) {
          store.dispatch(OnboardingSignupSuccessEventAction());
        } else if (response is CreatePersonErrorResponse) {
          store.dispatch(OnboardingSignupFailedEventAction());
        }
      } catch (e) {
        store.dispatch(OnboardingSignupFailedServerEventAction());
      }
    }
  }
}
