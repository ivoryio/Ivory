import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/onboarding/password/onboarding_password_action.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/field_validators.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

class OnboardingPasswordScreen extends StatefulWidget {
  static const routeName = "/onboardingPasswordScreen";

  const OnboardingPasswordScreen({super.key});

  @override
  State<OnboardingPasswordScreen> createState() => _OnboardingPasswordScreenState();
}

class _OnboardingPasswordScreenState extends State<OnboardingPasswordScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();
  bool showPassword = false;
  bool isButtonEnabled = false;
  bool isValidPassword = true;

  @override
  void initState() {
    super.initState();

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
          LinearProgressIndicator(
            value: 40 / 100,
            color: ClientConfig.getColorScheme().secondary,
            backgroundColor: const Color(0xFFE9EAEB),
          ),
          Expanded(
            child: SingleChildScrollView(
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
                  Text('Password',
                      style: (isValidPassword == false && passwordFocusNode.hasFocus)
                          ? ClientConfig.getTextStyleScheme()
                              .labelSmall
                              .copyWith(color: ClientConfig.getColorScheme().error)
                          : ClientConfig.getTextStyleScheme().labelSmall),
                  const SizedBox(height: 8),
                  TextField(
                    style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                    controller: passwordController,
                    obscureText: !showPassword,
                    focusNode: passwordFocusNode,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      filled: true,
                      fillColor: ClientConfig.getCustomColors().neutral100,
                      focusColor: ClientConfig.getCustomColors().neutral100,
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                            width: 1,
                            color: (isValidPassword == false && passwordFocusNode.hasFocus)
                                ? ClientConfig.getColorScheme().error
                                : ClientConfig.getCustomColors().neutral500),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                            width: 1,
                            color: (isValidPassword == false && passwordFocusNode.hasFocus)
                                ? ClientConfig.getColorScheme().error
                                : ClientConfig.getCustomColors().neutral500),
                      ),
                      hintText: 'Type password',
                    ),
                    onChanged: (value) {
                      if (value == confirmPasswordController.text && value.isNotEmpty) {
                        setState(() {
                          isButtonEnabled = true;
                          isValidPassword = !validatorMessages.map((e) => e.validate(value)).contains(false);
                        });
                      } else {
                        setState(() {
                          isButtonEnabled = false;
                          isValidPassword = !validatorMessages.map((e) => e.validate(value)).contains(false);
                        });
                      }
                    },
                  ),
                  if (passwordFocusNode.hasFocus) ...[
                    const SizedBox(height: 8),
                    FieldValidators(
                      validators: validatorMessages,
                      controllers: [passwordController],
                    ),
                  ],
                  const SizedBox(height: 24),
                  Text('Repeat password',
                      style: (confirmPasswordController.text.isNotEmpty &&
                              confirmPasswordController.text != passwordController.text &&
                              confirmPasswordFocusNode.hasFocus)
                          ? ClientConfig.getTextStyleScheme()
                              .labelSmall
                              .copyWith(color: ClientConfig.getColorScheme().error)
                          : ClientConfig.getTextStyleScheme().labelSmall),
                  const SizedBox(height: 8),
                  TextField(
                    style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                    controller: confirmPasswordController,
                    obscureText: !showPassword,
                    focusNode: confirmPasswordFocusNode,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      filled: true,
                      fillColor: ClientConfig.getCustomColors().neutral100,
                      focusColor: ClientConfig.getCustomColors().neutral100,
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(width: 1, color: ClientConfig.getCustomColors().neutral400),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(width: 1, color: ClientConfig.getCustomColors().neutral500),
                      ),
                      hintText: 'Repeat password',
                    ),
                    onChanged: (value) {
                      if (value == passwordController.text && value.isNotEmpty) {
                        setState(() {
                          isButtonEnabled = true;
                        });
                      } else {
                        setState(() {
                          isButtonEnabled = false;
                        });
                      }
                    },
                  ),
                  if (confirmPasswordFocusNode.hasFocus) ...[
                    const SizedBox(height: 8),
                    FieldValidators(
                      controllers: [passwordController, confirmPasswordController],
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
                        child: Checkbox(
                          value: showPassword,
                          onChanged: (value) {
                            setState(() {
                              showPassword = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('Show passwords', style: ClientConfig.getTextStyleScheme().bodyLargeRegular),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
            child: SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: "Continue",
                onPressed: isButtonEnabled
                    ? () {
                        StoreProvider.of<AppState>(context)
                            .dispatch(OnboardingSubmitPasswordCommandAction(passwordController.text));

                        log('OnboardingPasswordScreen: passwordController.text: ${passwordController.text}');
                      }
                    : null,
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
