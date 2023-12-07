import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/onboarding/identity_verification/onboarding_identity_verification_service.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/documents/documents_action.dart';
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
      } else if (response is IdentityVerificationServiceErrorResponse) {
        store.dispatch(OnboardingIdentityVerificationErrorEventAction(errorType: response.errorType));
      }
    }

    if (action is GetSignupIdentificationInfoCommandAction) {
      store.dispatch(OnboardingIdentityVerificationLoadingEventAction());

      // needed because the bank ident status is not updated immediately after the bank ident is successful
      await Future.delayed(const Duration(seconds: 1));

      final response = await _onboardingIdentityVerificationService.getSignupIdentificationInfo(
        user: authState.cognitoUser,
      );

      if (response is GetSignupIdentificationInfoSuccessResponse) {
        store.dispatch(SignupIdentificationInfoFetchedEventAction(identificationStatus: response.identificationStatus));
        store.dispatch(DocumentsFetchedEventAction(documents: response.documents));
      } else if (response is IdentityVerificationServiceErrorResponse) {
        store.dispatch(OnboardingIdentityVerificationErrorEventAction(errorType: response.errorType));
      }
    }

    if (action is AuthorizeIdentificationSigningCommandAction) {
      store.dispatch(OnboardingIdentityAuthorizationLoadingEventAction());

      final response = await _onboardingIdentityVerificationService.authorizeIdentification(
        user: authState.cognitoUser,
      );

      if (response is AuthorizeIdentificationSuccessResponse) {
        store.dispatch(AuthorizeIdentificationSigningSuccessEventAction());
      } else if (response is IdentityVerificationServiceErrorResponse) {
        store.dispatch(OnboardingIdentityVerificationErrorEventAction(errorType: response.errorType));
      }
    }

    if (action is SignWithTanCommandAction) {
      store.dispatch(OnboardingIdentityVerificationLoadingEventAction());

      final response =
          await _onboardingIdentityVerificationService.signWithTan(user: authState.cognitoUser, tan: action.tan);

      if (response is SignWithTanSuccessResponse) {
        store.dispatch(SignWithTanSuccessEventAction());
      } else if (response is IdentityVerificationServiceErrorResponse) {
        store.dispatch(OnboardingIdentityVerificationErrorEventAction(errorType: response.errorType));
      }
    }

    if (action is GetCreditLimitCommandAction) {
      store.dispatch(OnboardingIdentityVerificationLoadingEventAction());

      final response = await _onboardingIdentityVerificationService.getCreditLimit(user: authState.cognitoUser);

      if (response is GetCreditLimitSuccessResponse) {
        store.dispatch(CreditLimitSuccessEventAction(approvedCreditLimit: response.creditLimit ~/ 100));
      } else if (response is IdentityVerificationServiceErrorResponse) {
        store.dispatch(OnboardingIdentityVerificationErrorEventAction(errorType: response.errorType));
      }
    }

    if (action is FinalizeIdentificationCommandAction) {
      store.dispatch(FinalizeIdentificationLoadingEventAction());

      final response = await _onboardingIdentityVerificationService.finalizeIdentification(user: authState.cognitoUser);

      if (response is FinalizeIdentificationServiceSuccessResponse) {
        store.dispatch(FinalizeIdentificationSuccessEventAction());
      } else if (response is IdentityVerificationServiceErrorResponse) {
        store.dispatch(OnboardingIdentityVerificationErrorEventAction(errorType: response.errorType));
      }
    }
  }
}
