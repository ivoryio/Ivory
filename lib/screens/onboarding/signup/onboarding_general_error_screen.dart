import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/screens/onboarding/onboarding_stepper_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/continue_button_controller.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

class OnboardingGeneralErrorScreen extends StatelessWidget {
  static const String routeName = '/onboardingGeneralErrorScreen';

  const OnboardingGeneralErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ContinueButtonController continueButtonController = ContinueButtonController(isEnabled: true);

    return ScreenScaffold(
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
                    listenable: continueButtonController,
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
                                  color: (continueButtonController.isLoading == false)
                                      ? ClientConfig.getColorScheme().secondary
                                      : ClientConfig.getCustomColors().neutral500,
                                ),
                          ),
                          const TextSpan(text: ' or '),
                          TextSpan(
                            text: 'support@ivory.com',
                            style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold.copyWith(
                                  color: (continueButtonController.isLoading == false)
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
                    listenable: continueButtonController,
                    builder: (context, child) => SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        text: "Try again",
                        isLoading: continueButtonController.isLoading,
                        onPressed: continueButtonController.isEnabled
                            ? () {
                                continueButtonController.setLoading();

                                log('continueButtonController.state ===> ${continueButtonController.state}');
                                Navigator.pushNamed(
                                  context,
                                  OnboardingStepperScreen.routeName,
                                );
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
