import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/redux/onboarding/signup/basic_info/onboarding_basic_info_action.dart';
import 'package:solarisdemo/redux/onboarding/signup/basic_info/onboarding_basic_info_state.dart';

import '../../../setup/create_app_state.dart';
import '../../../setup/create_store.dart';

void main() {
  test("When the user submits the basic info, the state should be updated", () async {
    //given
    final store = createTestStore(
      initialState: createAppState(
        onboardingBasicInfoState: OnboardingBasicInfoInitialState(),
      ),
    );
    final appState =
        store.onChange.firstWhere((state) => state.onboardingBasicInfoState is OnboardingBasicInfoSubmittedState);

    //when
    store.dispatch(const SubmitOnboardingBasicInfoCommandAction(
      title: "title",
      firstName: "firstName",
      lastName: "lastName",
    ));

    //then
    expect((await appState).onboardingBasicInfoState, isA<OnboardingBasicInfoSubmittedState>());
  });
}
