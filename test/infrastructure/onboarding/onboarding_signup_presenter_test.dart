import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/infrastructure/onboarding/onboarding_signup_presenter.dart';
import 'package:solarisdemo/models/onboarding/onboarding_signup_attributes.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_state.dart';

void main() {
  const signupAttributes = OnboardingSignupAttributes(
    email: "email",
    firstName: "firstName",
    lastName: "lastName",
    notificationsAllowed: true,
    password: "password",
    title: "title",
  );

  test("When signing up, the attributes from the state should match those from the view model", () {
    //given
    final state = OnboardingSignupState(
      signupAttributes: signupAttributes,
    );

    //when
    final viewModel = OnboardingSignupPresenter.present(signupState: state);

    //then
    expect(viewModel, const OnboardingSignupViewModel(signupAttributes: signupAttributes));
  });
}
