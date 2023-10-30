import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/onboarding/onboarding_signup_presenter.dart';
import 'package:solarisdemo/models/onboarding/onboarding_signup_error_type.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_action.dart';
import 'package:solarisdemo/screens/onboarding/onboarding_stepper_screen.dart';
import 'package:solarisdemo/screens/onboarding/signup/onboarding_error_email_screen.dart';
import 'package:solarisdemo/screens/welcome/welcome_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/continue_button_controller.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

class OnboardingGeneralErrorScreen extends StatefulWidget {
  static const String routeName = '/onboardingGeneralErrorScreen';

  const OnboardingGeneralErrorScreen({super.key});

  @override
  State<OnboardingGeneralErrorScreen> createState() => _OnboardingGeneralErrorScreenState();
}

class _OnboardingGeneralErrorScreenState extends State<OnboardingGeneralErrorScreen> {
  final ContinueButtonController _continueButtonController = ContinueButtonController(isEnabled: true);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OnboardingSignupViewModel>(
      converter: (store) => OnboardingSignupPresenter.present(
        signupState: store.state.onboardingSignupState,
        authState: store.state.authState,
      ),
      distinct: true,
      onWillChange: (previousViewModel, newViewModel) {
        if (newViewModel.isSuccessful == true) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            OnboardingStepperScreen.routeName,
            ModalRoute.withName(WelcomeScreen.routeName),
          );
        } else if (newViewModel.isSuccessful == false &&
            newViewModel.errorType == OnboardingSignupErrorType.emailAlreadyExists) {
          Navigator.pushReplacementNamed(context, OnboardingErrorEmailScreen.routeName);
        } else if (newViewModel.isLoading) {
          _continueButtonController.setLoading();
        } else if (newViewModel.errorType != null) {
          _continueButtonController.setEnabled();
        }
      },
      builder: (context, viewModel) {
        return ScreenScaffold(
          shouldPop: false,
          body: Column(
            children: [
              AppToolbar(
                padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                backButtonEnabled: false,
              ),
              Expanded(
                child: ScrollableScreenContainer(
                  padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'An error has occurred',
                          style: ClientConfig.getTextStyleScheme().heading1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListenableBuilder(
                        listenable: _continueButtonController,
                        builder: (context, child) => Text.rich(
                          TextSpan(
                            style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                            children: [
                              const TextSpan(
                                  text:
                                      'We\'re sorry, but it seems an error has cropped up, which is preventing you from completing this step. Here\'s what you can do:\n\n'),
                              TextSpan(
                                text:
                                    '1. Try closing the app and reopening it.\n\n2. Check your internet connection and try again.\n\n3. If the issue persists, reach out ',
                                style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                              ),
                              const TextSpan(text: 'to our friendly support team at '),
                              TextSpan(
                                text: '+49 (0)123 456789',
                                style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold.copyWith(
                                      color: (_continueButtonController.isLoading == false)
                                          ? ClientConfig.getColorScheme().secondary
                                          : ClientConfig.getCustomColors().neutral500,
                                    ),
                              ),
                              const TextSpan(text: ' or '),
                              TextSpan(
                                text: 'support@ivory.com',
                                style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold.copyWith(
                                      color: (_continueButtonController.isLoading == false)
                                          ? ClientConfig.getColorScheme().secondary
                                          : ClientConfig.getCustomColors().neutral500,
                                    ),
                              ),
                              const TextSpan(text: '. We\'re here to help.'),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: SvgPicture.asset('assets/images/general_error.svg'),
                      ),
                      ListenableBuilder(
                        listenable: _continueButtonController,
                        builder: (context, child) => SizedBox(
                          width: double.infinity,
                          child: PrimaryButton(
                            text: "Try again",
                            isLoading: _continueButtonController.isLoading,
                            onPressed: _continueButtonController.isEnabled
                                ? () => StoreProvider.of<AppState>(context).dispatch(CreateAccountCommandAction())
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
