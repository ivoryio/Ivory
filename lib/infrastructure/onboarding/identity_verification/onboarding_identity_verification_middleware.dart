import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/onboarding/identity_verification/onboarding_identity_verification_service.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/onboarding/identity_verification/onboarding_identity_verification_action.dart';

class OnboardingIdentityVerificationMiddleware extends MiddlewareClass<AppState> {
  final OnbordingIdentityVerificationService _onboardingIdentityVerificationService;

  OnboardingIdentityVerificationMiddleware(this._onboardingIdentityVerificationService);

  @override
  call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    next(action);

    final authState = store.state.authState;
    if (authState is! AuthenticationInitializedState) {
      return;
    }

    if (action is CreateUrlForIntegrationCommandAction) {
      store.dispatch(OnboardingIdentityVerificationLoadingEventAction());

      final response = await _onboardingIdentityVerificationService.createIdentification(
        user: authState.cognitoUser,
        accountName: action.accountName,
        iban: action.iban,
        termsAndCondsSignedAt: DateTime.now().toUtc().toIso8601String(),
      );

      if (response is CreateUrlForIntegrationSuccesResponse) {
        store.dispatch(CreateUrlForIntegrationSuccessEventAction(urlForIntegration: response.urlForIntegration));
      } else if (response is CreateUrlForIntegrationErrorResponse) {
        store.dispatch(CreateUrlForIntegrationFailedEventAction(errorType: response.errorType));
      }
    }
  }
}
