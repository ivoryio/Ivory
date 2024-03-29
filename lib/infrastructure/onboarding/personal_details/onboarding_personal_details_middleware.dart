import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/mobile_number/mobile_number_service.dart';
import 'package:solarisdemo/infrastructure/onboarding/personal_details/onboarding_personal_details_service.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/onboarding/personal_details/onboarding_personal_details_action.dart';

class OnboardingPersonalDetailsMiddleware extends MiddlewareClass<AppState> {
  final OnboardingPersonalDetailsService _onboardingPersonalDetailsService;
  final MobileNumberService _mobileNumberService;

  OnboardingPersonalDetailsMiddleware(
    this._onboardingPersonalDetailsService,
    this._mobileNumberService,
  );

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is CreatePersonAccountCommandAction) {
      if (store.state.authState is AuthenticationInitializedState) {
        store.dispatch(OnboardingPersonalDetailsLoadingEventAction());

        final user = (store.state.authState as AuthenticationInitializedState).cognitoUser;
        final personalDetailsAttributes = store.state.onboardingPersonalDetailsState.attributes;

        final birthCountry = personalDetailsAttributes.country;
        final nationality = personalDetailsAttributes.nationality;

        final response = await _onboardingPersonalDetailsService.createPerson(
          user: user,
          address: personalDetailsAttributes.selectedAddress!,
          birthCity: personalDetailsAttributes.city ?? "",
          birthCountry: birthCountry == "DEMO" ? "DE" : birthCountry ?? "",
          birthDate: personalDetailsAttributes.birthDate ?? "",
          nationality: nationality == "DEMO" ? "DE" : nationality ?? "",
          addressLine: action.addressLine,
        );

        if (response is OnboardingCreatePersonSuccessResponse) {
          store.dispatch(CreatePersonAccountSuccessEventAction(personId: response.personId));
        } else if (response is OnboardingPersonalDetailsServiceErrorResponse) {
          store.dispatch(CreatePersonAccountFailedEventAction(errorType: response.errorType));
        }
      }
    }

    if (action is CreateMobileNumberCommandAction) {
      if (store.state.authState is AuthenticationInitializedState) {
        store.dispatch(OnboardingPersonalDetailsLoadingEventAction());

        final user = (store.state.authState as AuthenticationInitializedState).cognitoUser;

        final response = await _mobileNumberService.createMobileNumber(
          mobileNumber: action.mobileNumber,
          user: user,
        );

        if (response is CreateMobileNumberSuccessResponse) {
          store.dispatch(MobileNumberCreatedEventAction(mobileNumber: action.mobileNumber));
        } else if (response is MobileNumberServiceErrorResponse) {
          store.dispatch(MobileNumberCreateFailedEventAction(errorType: response.errorType));
        }
      }
    }

    if (action is ConfirmMobileNumberCommandAction) {
      if (store.state.authState is AuthenticationInitializedState) {
        store.dispatch(OnboardingPersonalDetailsLoadingEventAction());

        final user = (store.state.authState as AuthenticationInitializedState).cognitoUser;

        final response = await _mobileNumberService.confirmMobileNumber(
          mobileNumber: action.mobileNumber,
          token: action.token,
          user: user,
        );

        if (response is ConfirmMobileNumberSuccessResponse) {
          store.dispatch(MobileNumberConfirmedEventAction());
        } else if (response is MobileNumberServiceErrorResponse) {
          store.dispatch(MobileNumberConfirmationFailedEventAction(errorType: response.errorType));
        }
      }
    }

    if (action is VerifyMobileNumberCommandAction) {
      if (store.state.authState is AuthenticationInitializedState) {
        final user = (store.state.authState as AuthenticationInitializedState).cognitoUser;

        final response = await _mobileNumberService.verifyMobileNumber(
          mobileNumber: action.mobileNumber,
          user: user,
        );

        if (response is VerifyMobileNumberSuccessResponse) {
          store.dispatch(MobileNumberVerifiedEventAction());
        } else if (response is MobileNumberServiceErrorResponse) {
          store.dispatch(MobileNumberCreateFailedEventAction(errorType: response.errorType));
        }
      }
    }
  }
}
