import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
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
  TextEditingController emailController = TextEditingController();
  bool isEmailValid = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isEmailValid = true;
      });
    });
    emailController.addListener(() {
      final email = emailController.text;
      setState(() {
        isEmailValid = isValidEmail(email);
      });
    });
  }

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegExp.hasMatch(email);
  }

  @override
  void dispose() {
    emailController.dispose();
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
            actions: [
              SvgPicture.asset("assets/icons/default/appbar_logo.svg"),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Email address', style: ClientConfig.getTextStyleScheme().heading2),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Enter your email address below.', style: ClientConfig.getTextStyleScheme().bodyLargeRegular),
                  const SizedBox(height: 24),
                  Text('Email address',
                      style: isEmailValid
                          ? ClientConfig.getTextStyleScheme().labelSmall
                          : ClientConfig.getTextStyleScheme().labelSmall.copyWith(color: Colors.red)),
                  const SizedBox(height: 8),
                  TextField(
                    style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: true,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                              width: 1,
                              color: isEmailValid
                                  ? ClientConfig.getCustomColors().neutral400
                                  : ClientConfig.getColorScheme().error),
                        ),
                        hintText: 'Type email address,'),
                  ),
                  isEmailValid
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
                onPressed: isEmailValid
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
