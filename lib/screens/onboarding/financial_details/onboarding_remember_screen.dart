import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/screens/welcome/welcome_screen.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

class OnboardingRememberScreen extends StatelessWidget {
  static const routeName = '/onboardingRememberScreen';

  const OnboardingRememberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        children: [
          AppToolbar(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            richTextTitle: StepRichTextTitle(step: 1, totalSteps: 5),
            actions: const [AppbarLogo()],
          ),
          AnimatedLinearProgressIndicator.step(current: 1, totalSteps: 5),
          Expanded(
            child: ScrollableScreenContainer(
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Remember...', style: ClientConfig.getTextStyleScheme().heading2)),
                  const SizedBox(height: 16),
                  Text.rich(
                    TextSpan(
                      style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                      children: [
                        const TextSpan(
                            text: 'In order to make the best out of our credit services, we need some additional '),
                        TextSpan(
                            text: 'personal & financial information',
                            style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold),
                        const TextSpan(
                            text: ' to score you, such as your living situation, occupation, income etc.\n\n'),
                        TextSpan(
                            text: 'Protecting your privacy',
                            style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold),
                        const TextSpan(
                            text: ' is our utmost priority. The information provided will solely be utilized '),
                        TextSpan(
                            text: 'for your scoring.', style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SvgPicture.asset('assets/images/onboarding_remember.svg'),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                        text: 'OK, continue',
                        onPressed: () {
                          Navigator.pushNamed(context, WelcomeScreen.routeName);
                        }),
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
