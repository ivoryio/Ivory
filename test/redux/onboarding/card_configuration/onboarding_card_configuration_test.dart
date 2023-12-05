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
        onboardingCardConfigurationService: FakeOnboardingCardConfigurationService(),
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
    expect(((await appState).onboardingCardConfigurationState as WithCardholderNameState).isLoading, false);
  });

  test("When fetching the cardholder name fails should return error state", () async{
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

  test("When waiting to create a card should return loading", () async{
    //given
    final store = createTestStore(
        onboardingCardConfigurationService: FakeOnboardingCardConfigurationService(),
        initialState: createAppState(
          onboardingCardConfigurationState: WithCardholderNameState(cardholderName: "Ivory TS"),
          authState: authState,
        ));

    final appState = store.onChange.firstWhere((element) {
      return element.onboardingCardConfigurationState is WithCardholderNameState &&
          (element.onboardingCardConfigurationState as WithCardholderNameState).isLoading == true;
    });
    //when
    store.dispatch(OnboardingCreateCardCommandAction());
    //then
    expect((await appState).onboardingCardConfigurationState, isA<WithCardholderNameState>());
    expect(((await appState).onboardingCardConfigurationState as WithCardholderNameState).isLoading, true);
  });

  test("When creating a card fails should return error state", () async{
    //given
    final store = createTestStore(
        onboardingCardConfigurationService: FakeFailingOnboardingCardConfigurationService(),
        initialState: createAppState(
          onboardingCardConfigurationState: WithCardholderNameState(cardholderName: "Ivory TS"),
          authState: authState,
        ));

    final appState = store.onChange.firstWhere((element) => element.onboardingCardConfigurationState is OnboardingCardConfigurationGenericErrorState);
    //when
    store.dispatch(OnboardingCreateCardCommandAction());
    //then
    expect((await appState).onboardingCardConfigurationState, isA<OnboardingCardConfigurationGenericErrorState>());
  });

  test("When creating a card is successful should return success", () async{
    //given
    final store = createTestStore(
        onboardingCardConfigurationService: FakeOnboardingCardConfigurationService(),
        initialState: createAppState(
          onboardingCardConfigurationState: WithCardholderNameState(cardholderName: "Ivory TS"),
          authState: authState,
        ));

    final appState = store.onChange.firstWhere((element) => element.onboardingCardConfigurationState is OnboardingCardConfigurationGenericSuccessState);
    //when
    store.dispatch(OnboardingCreateCardCommandAction());
    //then
    expect((await appState).onboardingCardConfigurationState, isA<OnboardingCardConfigurationGenericSuccessState>());
  });

  test("When getting the details of a card fails should return error state", () async{
    //given
    final store = createTestStore(
        onboardingCardConfigurationService: FakeFailingOnboardingCardConfigurationService(),
        initialState: createAppState(
          onboardingCardConfigurationState: WithCardholderNameState(cardholderName: "Ivory TS"),
          authState: authState,
        ));

    final appState = store.onChange.firstWhere((element) => element.onboardingCardConfigurationState is OnboardingCardConfigurationGenericErrorState);
    //when
    store.dispatch(GetOnboardingCardInfoCommandAction());
    //then
    expect((await appState).onboardingCardConfigurationState, isA<OnboardingCardConfigurationGenericErrorState>());
  });

  test("When getting the details of a card is successful should return success", () async{
    //given
    final store = createTestStore(
        onboardingCardConfigurationService: FakeOnboardingCardConfigurationService(),
        initialState: createAppState(
          onboardingCardConfigurationState: WithCardholderNameState(cardholderName: "Ivory TS"),
          authState: authState,
        ));

    final appState = store.onChange.firstWhere((element) => element.onboardingCardConfigurationState is WithCardInfoState);
    //when
    store.dispatch(GetOnboardingCardInfoCommandAction());
    //then
    expect((await appState).onboardingCardConfigurationState, isA<WithCardInfoState>());
    expect(((await appState).onboardingCardConfigurationState as WithCardInfoState).cardholderName, "Ivory TS");
    expect(((await appState).onboardingCardConfigurationState as WithCardInfoState).maskedPAN, "493441******6055");
    expect(((await appState).onboardingCardConfigurationState as WithCardInfoState).expiryDate, "09/26");
  });
}