import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/models/auth/auth_type.dart';

import 'package:solarisdemo/models/onboarding/onboarding_personal_details_attributes.dart';
import 'package:solarisdemo/models/onboarding/onboarding_personal_details_error_type.dart';
import 'package:solarisdemo/models/suggestions/address_suggestion.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/onboarding/personal_details/onboarding_personal_details_action.dart';
import 'package:solarisdemo/redux/onboarding/personal_details/onboarding_personal_details_state.dart';

import '../../../setup/create_app_state.dart';
import '../../../setup/create_store.dart';
import '../../auth/auth_mocks.dart';
import '../../transactions/transaction_mocks.dart';
import 'onboarding_personal_details_mocks.dart';

void main() {
  final mockUser = MockUser();
  final authInitializedState = AuthenticationInitializedState(mockUser, AuthType.onboarding);

  const birthDate = "03/11/2023";
  const country = "DE";
  const city = "Berlin";
  const nationality = "DE";
  const addressSuggestion = AddressSuggestion(address: 'address', city: 'city', country: 'DE');

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
          suggestion: addressSuggestion,
        ),
      );

      // then
      final onboardingPersonalDetailsState = (await appState).onboardingPersonalDetailsState;

      expect(onboardingPersonalDetailsState.attributes.selectedAddress, addressSuggestion);
    });

    group("Person creation", () {
      test("When the person is successfully created, <isAddressSaved> should change to true", () async {
        // given
        const attributes = OnboardingPersonalDetailsAttributes(
          birthDate: birthDate,
          city: city,
          country: country,
          nationality: nationality,
          selectedAddress: addressSuggestion,
        );

        final store = createTestStore(
          onboardingPersonalDetailsService: FakeOnboardingPersonalDetailsService(),
          initialState: createAppState(
            authState: authInitializedState,
            onboardingPersonalDetailsState: const OnboardingPersonalDetailsState(attributes: attributes),
          ),
        );

        final loadingState = store.onChange.firstWhere((state) => state.onboardingPersonalDetailsState.isLoading);
        final appState =
            store.onChange.firstWhere((state) => state.onboardingPersonalDetailsState.isAddressSaved == true);

        // when
        store.dispatch(CreatePersonAccountCommandAction(addressLine: "", houseNumber: ""));

        // then
        expect((await loadingState).onboardingPersonalDetailsState.isLoading, true);

        final onboardingPersonalDetailsState = (await appState).onboardingPersonalDetailsState;
        expect(onboardingPersonalDetailsState.attributes, attributes);
      });

      test("When the person failed to create, <isAddressSaved> should be false and <errorType> should not be null",
          () async {
        // given
        const attributes = OnboardingPersonalDetailsAttributes(
          birthDate: birthDate,
          city: city,
          country: country,
          nationality: nationality,
          selectedAddress: addressSuggestion,
        );

        final store = createTestStore(
          onboardingPersonalDetailsService: FakeFailingOnboardingPersonalDetailsService(),
          initialState: createAppState(
            authState: authInitializedState,
            onboardingPersonalDetailsState: const OnboardingPersonalDetailsState(attributes: attributes),
          ),
        );

        final loadingState = store.onChange.firstWhere((state) => state.onboardingPersonalDetailsState.isLoading);
        final appState =
            store.onChange.firstWhere((state) => state.onboardingPersonalDetailsState.isAddressSaved == false);

        // when
        store.dispatch(CreatePersonAccountCommandAction(addressLine: "", houseNumber: ""));

        // then
        expect((await loadingState).onboardingPersonalDetailsState.isLoading, true);

        final onboardingPersonalDetailsState = (await appState).onboardingPersonalDetailsState;
        expect(onboardingPersonalDetailsState.isAddressSaved, false);
        expect(onboardingPersonalDetailsState.attributes, attributes);
        expect(onboardingPersonalDetailsState.errorType, OnboardingPersonalDetailsErrorType.unknown);
      });
    });

    group("Create/confirm mobile number", () {
      test("When mobile number is created, tanRequestedAt should change", () async {
        //given
        const attributes = OnboardingPersonalDetailsAttributes(
          birthDate: birthDate,
          city: city,
          country: country,
          nationality: nationality,
          selectedAddress: addressSuggestion,
        );

        final store = createTestStore(
          onboardingPersonalDetailsService: FakeOnboardingPersonalDetailsService(),
          mobileNumberService: FakeMobileNumberService(),
          deviceService: FakeDeviceService(),
          deviceFingerprintService: FakeDeviceFingerprintService(),
          initialState: createAppState(
            authState: authInitializedState,
            onboardingPersonalDetailsState: const OnboardingPersonalDetailsState(attributes: attributes),
          ),
        );

        final loadingState = store.onChange.firstWhere((state) => state.onboardingPersonalDetailsState.isLoading);
        final appState = store.onChange.firstWhere((state) =>
            state.onboardingPersonalDetailsState.tanRequestedAt != null &&
            state.onboardingPersonalDetailsState.attributes.mobileNumber == '123456');

        // when
        store.dispatch(CreateMobileNumberCommandAction(mobileNumber: '123456'));

        //then
        expect((await loadingState).onboardingPersonalDetailsState.isLoading, true);

        final onboardingPersonalDetailsState = (await appState).onboardingPersonalDetailsState;
        expect(onboardingPersonalDetailsState.tanRequestedAt, isNotNull);
        expect(onboardingPersonalDetailsState.attributes.mobileNumber, '123456');
      });

      test("When mobile number confirmation happens, isMobileConfirmed should be true", () async {
        //given
        const attributes = OnboardingPersonalDetailsAttributes(
          birthDate: birthDate,
          city: city,
          country: country,
          nationality: nationality,
          selectedAddress: addressSuggestion,
          mobileNumber: '+15550101',
        );

        final store = createTestStore(
          onboardingPersonalDetailsService: FakeOnboardingPersonalDetailsService(),
          mobileNumberService: FakeMobileNumberService(),
          deviceService: FakeDeviceService(),
          deviceFingerprintService: FakeDeviceFingerprintService(),
          initialState: createAppState(
            authState: authInitializedState,
            onboardingPersonalDetailsState: const OnboardingPersonalDetailsState(attributes: attributes),
          ),
        );

        final loadingState = store.onChange.firstWhere((state) => state.onboardingPersonalDetailsState.isLoading);
        final appState =
            store.onChange.firstWhere((state) => state.onboardingPersonalDetailsState.isMobileConfirmed == true);

        // when
        store.dispatch(ConfirmMobileNumberCommandAction(mobileNumber: '+15550101', token: '212212'));

        //then
        expect((await loadingState).onboardingPersonalDetailsState.isLoading, true);

        final onboardingPersonalDetailsState = (await appState).onboardingPersonalDetailsState;
        expect(onboardingPersonalDetailsState.isMobileConfirmed, true);
      });
    });
  });
}
