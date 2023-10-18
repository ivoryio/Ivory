import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/onboarding/signup/email/onboarding_email_action.dart';
import 'package:solarisdemo/screens/onboarding/signup/onboarding_password_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

class OnboardingEmailScreen extends StatefulWidget {
  static const routeName = "/onboardingEmailScreen";

  const OnboardingEmailScreen({super.key});

  @override
  State<OnboardingEmailScreen> createState() => _OnboardingEmailScreenState();
}

class _OnboardingEmailScreenState extends State<OnboardingEmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isEmailValid = true;
  bool _canContinue = false;

  @override
  void initState() {
    super.initState();

    _emailController.addListener(() {
      final email = _emailController.text;

      setState(() {
        _isEmailValid = isValidEmail(email);
        _canContinue = _isEmailValid;
      });
    });
  }

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');

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
          LinearProgressIndicator(
            value: 20 / 100,
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
                    child: Text('Email address', style: ClientConfig.getTextStyleScheme().heading2),
                  ),
                  Text('Enter your email address below.', style: ClientConfig.getTextStyleScheme().bodyLargeRegular),
                  const SizedBox(height: 24),
                  Text('Email address',
                      style: _isEmailValid
                          ? ClientConfig.getTextStyleScheme().labelSmall
                          : ClientConfig.getTextStyleScheme()
                              .labelSmall
                              .copyWith(color: ClientConfig.getColorScheme().error)),
                  const SizedBox(height: 8),
                  TextField(
                    style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        filled: true,
                        fillColor: (_isEmailValid == false)
                            ? ClientConfig.getCustomColors().red100
                            : ClientConfig.getCustomColors().neutral100,
                        focusColor: (_isEmailValid == false)
                            ? ClientConfig.getCustomColors().red100
                            : ClientConfig.getCustomColors().neutral100,
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                              width: 1,
                              color: (_isEmailValid == false)
                                  ? ClientConfig.getColorScheme().error
                                  : ClientConfig.getCustomColors().neutral500),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                              width: 1,
                              color: (_isEmailValid == false)
                                  ? ClientConfig.getColorScheme().error
                                  : ClientConfig.getCustomColors().neutral500),
                        ),
                        hintText: 'Type email address'),
                  ),
                  const SizedBox(height: 8),
                  _isEmailValid
                      ? const SizedBox()
                      : const Text('Please input a valid email address.',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            height: 1.6,
                            color: Colors.red,
                          ))
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
                onPressed: _canContinue
                    ? () {
                        StoreProvider.of<AppState>(context).dispatch(
                          OnboardingSubmitEmailCommandAction(
                            _emailController.text,
                          ),
                        );

                        Navigator.pushNamed(context, OnboardingPasswordScreen.routeName);
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
