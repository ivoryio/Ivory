import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/models/auth/auth_type.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/onboarding/personal_details/onboarding_personal_details_action.dart';
import 'package:solarisdemo/redux/onboarding/personal_details/onboarding_personal_details_state.dart';

import '../../../infrastructure/repayments/more_credit/more_credit_presenter_test.dart';
import '../../../setup/create_app_state.dart';
import '../../../setup/create_store.dart';
import 'onboarding_personal_details_mocks.dart';

void main() {
  final user = MockUser();
  final authentionInitializedState = AuthenticationInitializedState(user, AuthType.withTan);

  group("Address of residence", () {
    test("When address suggestions are requested and arrive succesfully, state should be updated", () async {
      //given
      final store = createTestStore(
        onboardingService: FakeOnboardingService(),
        initialState: createAppState(
          authState: authentionInitializedState,
          onboardingPersonalDetailsState: OnboardingPersonalDetailsInitialState(),
        ),
      );

      final appState = store.onChange.firstWhere((element) =>
          element.onboardingPersonalDetailsState is OnboardingPersonalDetailsAddressSuggestionsFetchedState);

      //when
      store.dispatch(FetchOnboardingPersonalDetailsAddressSuggestionsCommandAction(queryString: "query"));

      //then
      expect((await appState).onboardingPersonalDetailsState,
          isA<OnboardingPersonalDetailsAddressSuggestionsFetchedState>());
      expect((await appState).onboardingPersonalDetailsState,
          OnboardingPersonalDetailsAddressSuggestionsFetchedState(mockSuggestions));
    });
    test("When address suggestion is selected, state should be updated", () async {
      //given
      final store = createTestStore(
        onboardingService: FakeOnboardingService(),
        initialState: createAppState(
          authState: authentionInitializedState,
          onboardingPersonalDetailsState: OnboardingPersonalDetailsAddressSuggestionsFetchedState(mockSuggestions),
        ),
      );

      final appState = store.onChange.firstWhere((element) =>
          element.onboardingPersonalDetailsState is OnboardingPersonalDetailsAddressSuggestionSelectedState);

      //when
      store.dispatch(
          SelectOnboardingPersonalDetailsAddressSuggestionCommandAction(selectedSuggestion: mockSelectedSuggestion));

      //then
      expect((await appState).onboardingPersonalDetailsState,
          isA<OnboardingPersonalDetailsAddressSuggestionSelectedState>());
      expect((await appState).onboardingPersonalDetailsState,
          OnboardingPersonalDetailsAddressSuggestionSelectedState(mockSelectedSuggestion));
    });
  });
}
