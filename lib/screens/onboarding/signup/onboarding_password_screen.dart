import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/onboarding/onboarding_signup_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_action.dart';
import 'package:solarisdemo/screens/onboarding/signup/onboarding_allow_notifications_screen.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/continue_button_controller.dart';
import 'package:solarisdemo/widgets/field_validators.dart';
import 'package:solarisdemo/widgets/ivory_text_field.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

class OnboardingPasswordScreen extends StatefulWidget {
  static const routeName = "/onboardingPasswordScreen";

  const OnboardingPasswordScreen({super.key});

  @override
  State<OnboardingPasswordScreen> createState() => _OnboardingPasswordScreenState();
}

class _OnboardingPasswordScreenState extends State<OnboardingPasswordScreen> {
  final IvoryTextFieldController passwordController = IvoryTextFieldController(obscureText: true);
  final IvoryTextFieldController confirmPasswordController = IvoryTextFieldController(obscureText: true);
  final ContinueButtonController _continueButtonController = ContinueButtonController();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _continueButtonController.setDisabled();
  }

  void _checkPasswordsMatch() {
    if (!mounted) {
      return;
    }

    if (passwordController.text == confirmPasswordController.text) {
      _continueButtonController.setEnabled();
    } else {
      _continueButtonController.setDisabled();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OnboardingSignupViewModel>(
      converter: (store) => OnboardingSignupPresenter.presentSignup(signupState: store.state.onboardingSignupState),
      builder: (context, viewModel) {
        return ScreenScaffold(
          body: Column(
            children: [
              AppToolbar(
                padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                richTextTitle: StepRichTextTitle(step: 3, totalSteps: 5),
                actions: const [AppbarLogo()],
              ),
              AnimatedLinearProgressIndicator.step(current: 3, totalSteps: 5),
              Expanded(
                child: ScrollableScreenContainer(
                  padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Password', style: ClientConfig.getTextStyleScheme().heading2),
                      ),
                      const SizedBox(height: 16),
                      Text('Choose your password and verify it below.',
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegular),
                      const SizedBox(height: 24),
                      IvoryTextField(
                        label: 'Password',
                        controller: passwordController,
                        focusNode: passwordFocusNode,
                      ),
                      ListenableBuilder(
                        listenable: passwordFocusNode,
                        builder: (context, child) {
                          return passwordFocusNode.hasFocus
                              ? Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  child: FieldValidators(
                                    validators: passwordValidators,
                                    controller: passwordController.textEditingController,
                                    onInvalid: () {
                                      passwordController.setError(true);
                                      _checkPasswordsMatch();
                                    },
                                    onValid: () {
                                      passwordController.setError(false);
                                      _checkPasswordsMatch();
                                    },
                                  ),
                                )
                              : Container();
                        },
                      ),
                      const SizedBox(height: 24),
                      IvoryTextField(
                        label: 'Repeat password',
                        controller: confirmPasswordController,
                        focusNode: confirmPasswordFocusNode,
                      ),
                      ListenableBuilder(
                        listenable: confirmPasswordFocusNode,
                        builder: (context, child) {
                          return confirmPasswordFocusNode.hasFocus
                              ? Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  child: FieldValidators(
                                    controller: confirmPasswordController.textEditingController,
                                    onInvalid: () {
                                      confirmPasswordController.setError(true);
                                      _checkPasswordsMatch();
                                    },
                                    onValid: () {
                                      confirmPasswordController.setError(false);
                                      _checkPasswordsMatch();
                                    },
                                    validators: [
                                      FieldValidator(
                                        label: 'Passwords match',
                                        validate: (input) {
                                          return input.isNotEmpty &&
                                              input == passwordController.text &&
                                              input == confirmPasswordController.text;
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              : Container();
                        },
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: ListenableBuilder(
                              listenable: Listenable.merge([
                                passwordController,
                                confirmPasswordController,
                              ]),
                              builder: (context, child) => Checkbox(
                                value: !passwordController.obscureText && !confirmPasswordController.obscureText,
                                onChanged: (value) {
                                  if (value == null) return;
                                  passwordController.setObscureText(!value);
                                  confirmPasswordController.setObscureText(!value);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('Show passwords', style: ClientConfig.getTextStyleScheme().bodyLargeRegular),
                        ],
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: ListenableBuilder(
                          listenable: _continueButtonController,
                          builder: (context, child) => PrimaryButton(
                            text: "Continue",
                            isLoading: _continueButtonController.isLoading,
                            onPressed: _continueButtonController.isEnabled
                                ? () {
                                    StoreProvider.of<AppState>(context).dispatch(
                                      SubmitOnboardingSignupCommandAction(
                                        signupAttributes: OnboardingSignupAttributes(
                                          title: StoreProvider.of<AppState>(context).state.onboardingSignupState.title,
                                          firstName:
                                              StoreProvider.of<AppState>(context).state.onboardingSignupState.firstName,
                                          lastName:
                                              StoreProvider.of<AppState>(context).state.onboardingSignupState.lastName,
                                          email: StoreProvider.of<AppState>(context).state.onboardingSignupState.email,
                                          password: StoreProvider.of<AppState>(context)
                                                  .state
                                                  .onboardingSignupState
                                                  .password ??
                                              passwordController.text,
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

                                    Navigator.pushNamed(context, OnboardingAllowNotificationsScreen.routeName);
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
      },
    );
  }
}

List<FieldValidator> passwordValidators = [
  CustomFieldValidators.minCharacters(8),
  CustomFieldValidators.minNumbers(1),
  CustomFieldValidators.uppercase(),
  CustomFieldValidators.lowercase(),
];
