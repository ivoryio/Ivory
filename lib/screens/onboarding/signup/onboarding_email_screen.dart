import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_action.dart';
import 'package:solarisdemo/screens/onboarding/signup/onboarding_password_screen.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/continue_button_controller.dart';
import 'package:solarisdemo/widgets/ivory_text_field.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

class OnboardingEmailScreen extends StatefulWidget {
  static const routeName = "/onboardingEmailScreen";

  const OnboardingEmailScreen({super.key});

  @override
  State<OnboardingEmailScreen> createState() => _OnboardingEmailScreenState();
}

class _OnboardingEmailScreenState extends State<OnboardingEmailScreen> {
  final IvoryTextFieldController _emailController = IvoryTextFieldController();
  final ContinueButtonController _continueButtonController = ContinueButtonController();

  @override
  void initState() {
    super.initState();

    _emailController.addListener(() {
      final email = _emailController.text;
      email.isNotEmpty ? _continueButtonController.setEnabled() : _continueButtonController.setDisabled();

      if (isValidEmail(email) && _emailController.hasError) {
        _emailController.setError(false);
      }
    });
  }

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-+]+(\.[\w-+]+)*@[\w-]+(\.[\w-]+)+$');

    return emailRegExp.hasMatch(email);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        children: [
          AppToolbar(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            richTextTitle: StepRichTextTitle(step: 2, totalSteps: 5),
            actions: const [AppbarLogo()],
          ),
          AnimatedLinearProgressIndicator.step(current: 2, totalSteps: 5),
          Expanded(
            child: ScrollableScreenContainer(
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Email address', style: ClientConfig.getTextStyleScheme().heading2),
                  ),
                  const SizedBox(height: 16),
                  Text('Enter your email address below.', style: ClientConfig.getTextStyleScheme().bodyLargeRegular),
                  const SizedBox(height: 24),
                  IvoryTextField(
                    label: 'Email address',
                    placeholder: 'Type email address',
                    controller: _emailController,
                    inputType: TextFieldInputType.email,
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
                                if (isValidEmail(_emailController.text)) {
                                  StoreProvider.of<AppState>(context).dispatch(
                                    SubmitOnboardingEmailCommandAction(email: _emailController.text),
                                  );

                                  Navigator.pushNamed(context, OnboardingPasswordScreen.routeName);
                                } else {
                                  _emailController
                                      .setErrorText('Please input a valid email address (e.g. name@domain.com).');
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
