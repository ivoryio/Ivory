import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/redux/onboarding/card_configuration/onboarding_card_configuration_action.dart';
import 'package:solarisdemo/redux/onboarding/card_configuration/onboarding_card_configuration_state.dart';

import '../../../setup/authentication_helper.dart';
import '../../../setup/create_app_state.dart';
import '../../../setup/create_store.dart';
import 'onboarding_card_configuration_mocks.dart';

void main() {
  final authState = AuthStatePlaceholder.inOnboardingState();

  test("When fetching the cardholder name is successful should return state with name", () async{
    //given
    final store = createTestStore(
        onboardingCardConfigurationService: FakeOnbordingCardConfigurationService(),
        initialState: createAppState(
          onboardingCardConfigurationState: OnboardingCardConfigurationInitialState(),
          authState: authState,
        ));

    final appState = store.onChange.firstWhere((element) => element.onboardingCardConfigurationState is WithCardholderNameState);
    //when
    store.dispatch(GetCardPersonNameCommandAction());
    //then
    expect((await appState).onboardingCardConfigurationState, isA<WithCardholderNameState>());
    expect(((await appState).onboardingCardConfigurationState as WithCardholderNameState).cardholderName, "Ivory TS");
  });

  test("When fetching the cardholder name fails shoul return error state", () async{
    //given
    final store = createTestStore(
        onboardingCardConfigurationService: FakeFailingOnboardingCardConfigurationService(),
        initialState: createAppState(
          onboardingCardConfigurationState: OnboardingCardConfigurationInitialState(),
          authState: authState,
        ));

    final appState = store.onChange.firstWhere((element) => element.onboardingCardConfigurationState is OnboardingCardConfigurationGenericErrorState);
    //when
    store.dispatch(GetCardPersonNameCommandAction());
    //then
    expect((await appState).onboardingCardConfigurationState, isA<OnboardingCardConfigurationGenericErrorState>());
  });
}