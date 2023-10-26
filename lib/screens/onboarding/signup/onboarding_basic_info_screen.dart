import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_action.dart';
import 'package:solarisdemo/screens/onboarding/signup/onboarding_email_screen.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/continue_button_controller.dart';
import 'package:solarisdemo/widgets/ivory_select_option.dart';
import 'package:solarisdemo/widgets/ivory_text_field.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

class OnboardingBasicInfoScreen extends StatefulWidget {
  static const routeName = '/onboardingBasicInfoScreen';

  const OnboardingBasicInfoScreen({super.key});

  @override
  State<OnboardingBasicInfoScreen> createState() => _OnboardingBasicInfoScreenState();
}

class _OnboardingBasicInfoScreenState extends State<OnboardingBasicInfoScreen> {
  final IvorySelectOptionController _selectTitleController = IvorySelectOptionController();
  final IvoryTextFieldController _firstNameController = IvoryTextFieldController();
  final IvoryTextFieldController _lastNameController = IvoryTextFieldController();
  final ContinueButtonController _continueButtonController = ContinueButtonController();

  @override
  void initState() {
    super.initState();

    _selectTitleController.addListener(onChange);
    _firstNameController.addListener(onChange);
    _lastNameController.addListener(onChange);
  }

  void onChange() {
    if (_selectTitleController.selectedOptions.isEmpty ||
        _firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty) {
      _continueButtonController.setDisabled();
    } else {
      _continueButtonController.setEnabled();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        children: [
          AppToolbar(
            richTextTitle: StepRichTextTitle(step: 1, totalSteps: 5),
            actions: const [AppbarLogo()],
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
          ),
          AnimatedLinearProgressIndicator.step(current: 1, totalSteps: 5),
          Expanded(
            child: ScrollableScreenContainer(
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text("Preferred title, first & last name", style: ClientConfig.getTextStyleScheme().heading2),
                  const SizedBox(height: 16),
                  Text(
                    "Select your title and fill in your first and last name. Include all names if you have multiple.",
                    style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                  ),
                  const SizedBox(height: 24),
                  IvorySelectOption(
                    label: "Preferred title",
                    bottomSheetLabel: "Select your preferred title",
                    controller: _selectTitleController,
                    onBottomSheetOpened: () => FocusScope.of(context).unfocus(),
                    options: const [
                      SelectOption(label: "Mr.", value: "mr"),
                      SelectOption(label: "Ms.", value: "ms"),
                      SelectOption(label: "Other", value: "other"),
                    ],
                  ),
                  const SizedBox(height: 24),
                  IvoryTextField(
                    label: "First name(s)",
                    placeholder: "Type first name",
                    controller: _firstNameController,
                    inputType: TextFieldInputType.name,
                  ),
                  const SizedBox(height: 24),
                  IvoryTextField(
                    label: "Last name(s)",
                    placeholder: "Type last name",
                    controller: _lastNameController,
                    inputType: TextFieldInputType.name,
                  ),
                  const Spacer(),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ListenableBuilder(
                      listenable: _continueButtonController,
                      builder: (context, child) => PrimaryButton(
                        text: "Continue",
                        isLoading: _continueButtonController.isLoading,
                        onPressed: _continueButtonController.isEnabled
                            ? () {
                                _continueButtonController.setLoading();
                                log(_selectTitleController.selectedOptions.toString(), name: "selectedOptions");
                                log(_firstNameController.text, name: "firstName");
                                log(_lastNameController.text, name: "lastName");

                                StoreProvider.of<AppState>(context).dispatch(
                                  SubmitOnboardingSignupCommandAction(
                                    signupAttributes: OnboardingSignupAttributes(
                                      title: _selectTitleController.selectedOptions.first.value,
                                      firstName: _firstNameController.text,
                                      lastName: _lastNameController.text,
                                      email: StoreProvider.of<AppState>(context).state.onboardingSignupState.email,
                                      password:
                                          StoreProvider.of<AppState>(context).state.onboardingSignupState.password,
                                      pushNotificationsAllowed: StoreProvider.of<AppState>(context)
                                          .state
                                          .onboardingSignupState
                                          .notificationsAllowed,
                                      tsAndCsSignedAt: StoreProvider.of<AppState>(context)
                                          .state
                                          .onboardingSignupState
                                          .tsAndCsSignedAt,
                                    ),
                                  ),
                                );

                                Navigator.pushNamed(context, OnboardingEmailScreen.routeName);
                              }
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
  }
}
