import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/onboarding/signup/password/onboarding_password_action.dart';
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
  final ContinueButtonController _continueButtonController = ContinueButtonController();
  IvoryTextFieldController passwordController = IvoryTextFieldController(
    obscureText: true,
  );
  IvoryTextFieldController confirmPasswordController = IvoryTextFieldController(
    obscureText: true,
  );
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();
  // bool showPassword = false;
  bool isValidPassword = true;

  @override
  void initState() {
    super.initState();

    _continueButtonController.setDisabled();

    passwordFocusNode.addListener(() => setState(() {}));
    confirmPasswordFocusNode.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
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
                    obscureText: true,
                    focusNode: passwordFocusNode,
                    // onChanged: (value) {
                    //   setState(() {
                    //     isValidPassword = !validatorMessages.map((e) => e.validate(value)).contains(false);
                    //   });

                    //   if (isValidPassword && value == confirmPasswordController.text && value.isNotEmpty) {
                    //     setState(() {
                    //       _continueButtonController.setEnabled();
                    //     });
                    //   } else {
                    //     setState(() {
                    //       _continueButtonController.setDisabled();
                    //     });
                    //   }
                    // },
                  ),
                  // Text('Password',
                  //     style: (isValidPassword == false && passwordFocusNode.hasFocus)
                  //         ? ClientConfig.getTextStyleScheme()
                  //             .labelSmall
                  //             .copyWith(color: ClientConfig.getColorScheme().error)
                  //         : ClientConfig.getTextStyleScheme().labelSmall),
                  // const SizedBox(height: 8),
                  // TextField(
                  //   style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                  //   controller: passwordController,
                  //   obscureText: !showPassword,
                  //   focusNode: passwordFocusNode,
                  //   decoration: InputDecoration(
                  //     contentPadding: const EdgeInsets.symmetric(
                  //       horizontal: 16,
                  //       vertical: 12,
                  //     ),
                  //     filled: true,
                  //     fillColor: ClientConfig.getCustomColors().neutral100,
                  //     focusColor: ClientConfig.getCustomColors().neutral100,
                  //     border: OutlineInputBorder(
                  //       borderRadius: const BorderRadius.all(Radius.circular(8)),
                  //       // borderSide: BorderSide(
                  //       //     width: 1,
                  //       //     color: (isValidPassword == false && passwordFocusNode.hasFocus)
                  //       //         ? ClientConfig.getColorScheme().error
                  //       //         : ClientConfig.getCustomColors().neutral500),
                  //       borderSide: BorderSide(width: 1, color: ClientConfig.getCustomColors().neutral500),
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderRadius: const BorderRadius.all(Radius.circular(8)),
                  //       // borderSide: BorderSide(
                  //       //     width: 1,
                  //       //     color: (isValidPassword == false && passwordFocusNode.hasFocus)
                  //       //         ? ClientConfig.getColorScheme().error
                  //       //         : ClientConfig.getCustomColors().neutral500),
                  //       borderSide: BorderSide(width: 1, color: ClientConfig.getCustomColors().neutral500),
                  //     ),
                  //     hintText: 'Type password',
                  //   ),
                  //   onChanged: (value) {
                  //     setState(() {
                  //       isValidPassword = !validatorMessages.map((e) => e.validate(value)).contains(false);
                  //     });

                  //     if (isValidPassword && value == confirmPasswordController.text && value.isNotEmpty) {
                  //       setState(() {
                  //         _continueButtonController.setEnabled();
                  //       });
                  //     } else {
                  //       setState(() {
                  //         _continueButtonController.setDisabled();
                  //       });
                  //     }
                  //   },
                  // ),
                  if (passwordFocusNode.hasFocus) ...[
                    const SizedBox(height: 8),
                    FieldValidators(
                      validators: validatorMessages,
                      controllers: [passwordController.textEditingController],
                    ),
                  ],
                  const SizedBox(height: 24),
                  IvoryTextField(
                    label: 'Repeat password',
                    controller: confirmPasswordController,
                    // obscureText: confirmPasswordController.setObscureText(),
                    focusNode: confirmPasswordFocusNode,
                    // onChanged: (value) {
                    //   if (value == passwordController.text && value.isNotEmpty && isValidPassword) {
                    //     setState(() {
                    //       _continueButtonController.setEnabled();
                    //     });
                    //   } else {
                    //     setState(() {
                    //       _continueButtonController.setDisabled();
                    //     });
                    //   }
                    // },
                  ),
                  // Text('Repeat password',
                  //     style: (confirmPasswordController.text.isNotEmpty &&
                  //             confirmPasswordController.text != passwordController.text &&
                  //             confirmPasswordFocusNode.hasFocus)
                  //         ? ClientConfig.getTextStyleScheme()
                  //             .labelSmall
                  //             .copyWith(color: ClientConfig.getColorScheme().error)
                  //         : ClientConfig.getTextStyleScheme().labelSmall),
                  // const SizedBox(height: 8),
                  // TextField(
                  //   style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                  //   controller: confirmPasswordController,
                  //   obscureText: !showPassword,
                  //   focusNode: confirmPasswordFocusNode,
                  //   decoration: InputDecoration(
                  //     contentPadding: const EdgeInsets.symmetric(
                  //       horizontal: 16,
                  //       vertical: 12,
                  //     ),
                  //     filled: true,
                  //     fillColor: ClientConfig.getCustomColors().neutral100,
                  //     focusColor: ClientConfig.getCustomColors().neutral100,
                  //     border: OutlineInputBorder(
                  //       borderRadius: const BorderRadius.all(Radius.circular(8)),
                  //       borderSide: BorderSide(width: 1, color: ClientConfig.getCustomColors().neutral400),
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderRadius: const BorderRadius.all(Radius.circular(8)),
                  //       borderSide: BorderSide(width: 1, color: ClientConfig.getCustomColors().neutral500),
                  //     ),
                  //     hintText: 'Repeat password',
                  //   ),
                  //   onChanged: (value) {
                  //     if (value == passwordController.text && value.isNotEmpty && isValidPassword) {
                  //       setState(() {
                  //         _continueButtonController.setEnabled();
                  //       });
                  //     } else {
                  //       setState(() {
                  //         _continueButtonController.setDisabled();
                  //       });
                  //     }
                  //   },
                  // ),
                  if (confirmPasswordFocusNode.hasFocus) ...[
                    const SizedBox(height: 8),
                    FieldValidators(
                      controllers: [
                        passwordController.textEditingController,
                        confirmPasswordController.textEditingController
                      ],
                      validators: [
                        FieldValidator(
                            label: 'Passwords match',
                            validate: (input) {
                              return input.isNotEmpty &&
                                  input == passwordController.text &&
                                  input == confirmPasswordController.text;
                            }),
                      ],
                    ),
                  ],
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
                                if (isValidPassword && passwordController.text == confirmPasswordController.text) {
                                  StoreProvider.of<AppState>(context)
                                      .dispatch(OnboardingSubmitPasswordCommandAction(passwordController.text));
                                } else {
                                  _continueButtonController.setDisabled();
                                }
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

List<FieldValidator> validatorMessages = [
  CustomFieldValidators.minCharacters(8),
  CustomFieldValidators.minNumbers(1),
  CustomFieldValidators.uppercase(),
  CustomFieldValidators.lowercase(),
];
