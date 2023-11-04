import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/models/auth/auth_type.dart';

import 'package:solarisdemo/models/onboarding/onboarding_personal_details_attributes.dart';
import 'package:solarisdemo/models/suggestions/address_suggestion.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/onboarding/personal_details/onboarding_personal_details_action.dart';
import 'package:solarisdemo/redux/onboarding/personal_details/onboarding_personal_details_state.dart';

import '../../../infrastructure/repayments/more_credit/more_credit_presenter_test.dart';
import '../../../setup/create_app_state.dart';
import '../../../setup/create_store.dart';

void main() {
  final user = MockUser();
  final authentionInitializedState = AuthenticationInitializedState(user, AuthType.withTan);

  const birthDate = "03/11/2023";
  const country = "DE";
  const city = "Berlin";
  const nationality = "DE";
  const address = "Berlin address";
  const postCode = "44135";
  const houseNumber = 63;
  const addressLine = "Berlin address line";

  group("Date & place of birth", () {
    test("When user submits the date and place of birth info, the state should be updated", () async {
      // given
      final store = createTestStore(
        initialState: createAppState(
          onboardingPersonalDetailsState: const OnboardingPersonalDetailsState(),
        ),
      );

      final appState =
          store.onChange.firstWhere((state) => state.onboardingPersonalDetailsState.attributes.hasBirthInfo);

      // when
      store.dispatch(
        SubmitOnboardingBirthInfoCommandAction(
          birthDate: birthDate,
          city: city,
          country: country,
          nationality: nationality,
        ),
      );

      // then
      final onboardingPersonalDetailsState = (await appState).onboardingPersonalDetailsState;

      expect(onboardingPersonalDetailsState.attributes.birthDate, birthDate);
      expect(onboardingPersonalDetailsState.attributes.city, city);
      expect(onboardingPersonalDetailsState.attributes.country, country);
      expect(onboardingPersonalDetailsState.attributes.nationality, nationality);
    });
  });

  group("Address of residence", () {
    test("When user has selected the address, the state should be updated", () async {
      // given
      final store = createTestStore(
        initialState: createAppState(
          onboardingPersonalDetailsState: const OnboardingPersonalDetailsState(
            attributes: OnboardingPersonalDetailsAttributes(
              birthDate: birthDate,
              city: city,
              country: country,
              nationality: nationality,
            ),
          ),
        ),
      );

      final appState =
          store.onChange.firstWhere((state) => state.onboardingPersonalDetailsState.attributes.hasBirthInfo);

      // when
      store.dispatch(
        SelectOnboardingAddressSuggestionCommandAction(
          suggestion: const AddressSuggestion(address: address, city: "city", country: "DE"),
        ),
      );

      // then
      final onboardingPersonalDetailsState = (await appState).onboardingPersonalDetailsState;

      expect(onboardingPersonalDetailsState.attributes.address, address);
    });
  });
}
