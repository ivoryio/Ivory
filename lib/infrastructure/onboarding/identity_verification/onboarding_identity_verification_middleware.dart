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

    if (action is CreateIdentificationCommandAction) {
      store.dispatch(OnboardingIdentityVerificationLoadingEventAction());

      final response = await _onboardingIdentityVerificationService.createIdentification(
        user: authState.cognitoUser,
        accountName: action.accountName,
        iban: action.iban,
        termsAndCondsSignedAt: DateTime.now().toUtc().toIso8601String(),
      );

      if (response is CreateIdentificationSuccessResponse) {
        store.dispatch(CreateIdentificationSuccessEventAction(urlForIntegration: response.urlForIntegration));
      } else if (response is CreateIdentificationErrorResponse) {
        store.dispatch(CreateIdentificationFailedEventAction(errorType: response.errorType));
      }
    }

    if (action is SignWithTanCommandAction) {
      store.dispatch(OnboardingIdentityVerificationLoadingEventAction());

      final response = await _onboardingIdentityVerificationService.signWithTan(tan: action.tan);

      if (response is SignWithTanSuccessResponse) {
        store.dispatch(SignWithTanSuccessEventAction());
      } else if (response is CreateIdentificationErrorResponse) {
        store.dispatch(CreateIdentificationFailedEventAction(errorType: response.errorType));
      }
    }
  }
}
