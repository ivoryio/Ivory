import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/screens/onboarding/onboarding_stepper_screen.dart';
import 'package:solarisdemo/screens/onboarding/start/onboarding_usa_tax_payer_error_screen.dart';
import 'package:solarisdemo/utilities/ivory_color_mapper.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/modal.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/screen_title.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingUsaTaxPayerScreen extends StatelessWidget {
  static const routeName = "/onboardingUsaTaxPayerScreen";

  const OnboardingUsaTaxPayerScreen({super.key});

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
                  const ScreenTitle("Are you a USA tax payer?"),
                  const SizedBox(height: 16),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: "If you as the account holder are "),
                        TextSpan(
                          text: "established in the USA",
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                        ),
                        const TextSpan(text: ", have been in the past or have "),
                        TextSpan(
                          text: "tax residency in the USA",
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                        ),
                        const TextSpan(text: ", we will not be able to open your credit account."),
                      ],
                      style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => showBottomModal(
                      context: context,
                      title: "How to top up your Ivory account?",
                      content: const _TaxpayerBottomSheetContent(),
                    ),
                    child: Text(
                      "Why am I being asked this?",
                      style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold.copyWith(
                            color: ClientConfig.getColorScheme().secondary,
                          ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: SvgPicture(
                        SvgAssetLoader(
                          "assets/images/usa_illustration.svg",
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
                      text: "Yes, I am a USA tax payer",
                      onPressed: () => Navigator.pushNamed(context, OnboardingUsaTaxPayerErrorScreen.routeName),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: "No, I'm not a USA taxpayer",
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          OnboardingStepperScreen.routeName,
                          arguments: OnboardingStepperScreenParams(step: OnboardingStepType.signUp),
                        );
                      },
                    ),
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

class _TaxpayerBottomSheetContent extends StatelessWidget {
  const _TaxpayerBottomSheetContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: "The "),
              TextSpan(
                text: "Foreign Account Tax Compliance Act (FATCA)",
                style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
              ),
              const TextSpan(
                  text:
                      ", generally requires that foreign financial Institutions and certain other non-financial foreign entities report on the foreign assets held by their U.S. account holders or be subject to withholding on withholdable payments."),
            ],
            style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
          ),
        ),
        const SizedBox(height: 16),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: "Read more on "),
              TextSpan(
                text: "www.irs.gov",
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrl(
                      Uri.parse("https://www.irs.gov"),
                    );
                  },
                style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold.copyWith(
                      color: ClientConfig.getColorScheme().secondary,
                    ),
              ),
              const TextSpan(text: "."),
            ],
            style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
