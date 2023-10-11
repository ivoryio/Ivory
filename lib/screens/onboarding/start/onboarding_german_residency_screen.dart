import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/screens/onboarding/start/onboarding_usa_tax_payer_screen.dart';
import 'package:solarisdemo/utilities/ivory_color_mapper.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/screen_title.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';
import 'package:solarisdemo/screens/onboarding/start/onboarding_german_residency_error_screen.dart';

class OnboardingGermanResidencyScreen extends StatelessWidget {
  static const routeName = "/onboardingGermanResidencyScreen";

  const OnboardingGermanResidencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppToolbar(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            actions: [
              SvgPicture.asset('assets/icons/default/appbar_logo.svg'),
            ],
          ),
          Expanded(
            child: ScrollableScreenContainer(
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ScreenTitle("Do you live in Germany?"),
                  const SizedBox(height: 16),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: "We currently support users residing in "),
                        TextSpan(
                          text: "Germany only",
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                        ),
                        const TextSpan(text: ". If you do not, unfortunately, your application will be rejected.")
                      ],
                      style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: SvgPicture(
                        SvgAssetLoader(
                          "assets/images/germany_illustration.svg",
                          colorMapper: IvoryColorMapper(
                            baseColor: ClientConfig.getColorScheme().secondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: SecondaryButton(
                        borderWidth: 2,
                        text: "No, I don't live in Germany",
                        onPressed: () => Navigator.pushNamed(context, OnboardingGermanResidencyErrorScreen.routeName)),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                        text: "Yes, I live in Germany",
                        onPressed: () => Navigator.pushNamed(context, OnboardingUsaTaxPayerScreen.routeName)),
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
