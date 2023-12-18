import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/auth/auth_service.dart';
import 'package:solarisdemo/infrastructure/device/device_service.dart';
import 'package:solarisdemo/infrastructure/onboarding/onboarding_service.dart';
import 'package:solarisdemo/models/auth/auth_type.dart';
import 'package:solarisdemo/models/onboarding/onboarding_progress.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_action.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/onboarding/onboarding_progress_action.dart';
import 'package:solarisdemo/redux/onboarding/personal_details/onboarding_personal_details_action.dart';

class OnboardingProgressMiddleware extends MiddlewareClass<AppState> {
  final OnboardingService _onboardingService;
  final AuthService _authService;
  final DeviceService _deviceService;

  OnboardingProgressMiddleware(this._onboardingService, this._authService, this._deviceService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    User? cognitoUser;
    if (store.state.authState is AuthenticationInitializedState) {
      cognitoUser = (store.state.authState as AuthenticationInitializedState).cognitoUser;
    }

    if (action is GetOnboardingProgressCommandAction) {
      if (cognitoUser == null) {
        store.dispatch(OnboardingProgressFetchedEvendAction(step: OnboardingStep.start));
      } else {
        store.dispatch(OnboardingProgressLoadingEventAction());

        final response = await _onboardingService.getOnboardingProgress(user: cognitoUser);
        if (response is OnboardingProgressSuccessResponse) {
          store.dispatch(OnboardingProgressFetchedEvendAction(step: response.step));
          if (response.mobileNumber.isNotEmpty && response.creditCardApplicationId.isEmpty) {
            store.dispatch(MobileNumberCreatedEventAction(mobileNumber: response.mobileNumber));
          }
        } else {
          store.dispatch(OnboardingProgressFailedEventAction());
        }
      }
    }

    if (action is FinalizeOnboardingCommandAction) {
      if (cognitoUser != null) {
        store.dispatch(OnboardingProgressLoadingEventAction());

        final response = await _onboardingService.finalizeOnboarding(user: cognitoUser);
        if (response is OnboardingFinalizeSuccessResponse) {
          final credentials = await _deviceService.getCredentialsFromCache();
          if (credentials == null || credentials.email == null || credentials.password == null) {
            store.dispatch(OnboardingProgressFailedEventAction());
            return;
          }

          final authResponse = await _authService.login(
            credentials.email!,
            credentials.password!,
          );
          if (authResponse is LoginSuccessResponse) {
            store.dispatch(
              AuthenticateUserCommandAction(
                authType: AuthType.onboarding,
                cognitoUser: authResponse.user,
                onSuccess: () {
                  store.dispatch(OnboardingFinalizedEventAction());
                },
              ),
            );
          } else {
            store.dispatch(OnboardingProgressFailedEventAction());
          }
        } else {
          store.dispatch(OnboardingProgressFailedEventAction());
        }
      }
    }
  }
}
