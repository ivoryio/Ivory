import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
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
            actions: [
              SvgPicture.asset("assets/icons/default/appbar_logo.svg"),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Password', style: ClientConfig.getTextStyleScheme().heading2),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Choose your password and verify it below.',
                      style: ClientConfig.getTextStyleScheme().bodyLargeRegular),
                  const SizedBox(height: 24),
                  Text('Password', style: ClientConfig.getTextStyleScheme().labelSmall),
                  const SizedBox(height: 8),
                  TextField(
                    style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                    controller: passwordController,
                    obscureText: !showPassword,
                    focusNode: passwordFocusNode,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: ClientConfig.getCustomColors().neutral400),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      hintText: 'Type password',
                    ),
                    // onChanged: (value) {
                    //   setState(() => value = passwordController.text);
                    // },
                  ),
                  if (passwordFocusNode.hasFocus) ...[
                    const SizedBox(height: 8),
                    FieldValidators(
                      validators: validatorMessages,
                      controllers: [passwordController],
                    ),
                  ],
                  const SizedBox(height: 24),
                  Text('Repeat password', style: ClientConfig.getTextStyleScheme().labelSmall),
                  const SizedBox(height: 8),
                  TextField(
                    style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                    controller: confirmPasswordController,
                    obscureText: !showPassword,
                    focusNode: confirmPasswordFocusNode,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: ClientConfig.getCustomColors().neutral400),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      hintText: 'Repeat password',
                    ),
                    onChanged: (value) async {
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
                        log('onPressed');
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
