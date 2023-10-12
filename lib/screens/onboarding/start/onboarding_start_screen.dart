import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/screens/onboarding/start/onboarding_german_residency_screen.dart';
import 'package:solarisdemo/utilities/ivory_color_mapper.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/screen_title.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

class OnboardingStartScreen extends StatelessWidget {
  static const routeName = "/onboardingStartScreen";

  const OnboardingStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppToolbar(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            actions: const [AppbarLogo()],
          ),
          Expanded(
            child: ScrollableScreenContainer(
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ScreenTitle("It's quick and easy!"),
                  const SizedBox(height: 16),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: "Get your credit card instantly in just "),
                        TextSpan(
                          text: "25 minutes!",
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                        ),
                      ],
                      style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: "First we'll ask you "),
                        TextSpan(
                          text: "two quick questions ",
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                        ),
                        const TextSpan(text: "to ensure our services are tailored to your needs.")
                      ],
                      style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: SvgPicture(
                        SvgAssetLoader(
                          "assets/images/onboarding_start.svg",
                          colorMapper: IvoryColorMapper(
                            baseColor: ClientConfig.getColorScheme().secondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                        text: "Let's start",
                        onPressed: () => Navigator.pushNamed(context, OnboardingGermanResidencyScreen.routeName)),
                  ),
                  const SizedBox(height: 16)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
