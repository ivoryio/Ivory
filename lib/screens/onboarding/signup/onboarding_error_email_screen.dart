import 'dart:developer';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/screens/onboarding/signup/onboarding_email_screen.dart';
import 'package:solarisdemo/utilities/ivory_color_mapper.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/continue_button_controller.dart';
import 'package:solarisdemo/widgets/ivory_asset_with_badge.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

class OnboardingErrorEmailScreen extends StatelessWidget {
  static const String routeName = '/onboardingErrorEmailScreen';

  const OnboardingErrorEmailScreen({super.key});

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
                      'Email address already in use',
                      style: ClientConfig.getTextStyleScheme().heading1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text.rich(
                    TextSpan(
                      style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                      children: [
                        const TextSpan(text: 'The email address '),
                        TextSpan(
                          text: 'laura.lehmann@gmail.com',
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                        ),
                        const TextSpan(text: ' is already in use. Please choose a different one and try again.'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: IvoryAssetWithBadge(
                      childWidget: SvgPicture(
                        SvgAssetLoader(
                          'assets/images/email_already_use.svg',
                          colorMapper: IvoryColorMapper(
                            baseColor: ClientConfig.getColorScheme().secondary,
                          ),
                        ),
                      ),
                      childPosition: BadgePosition.topEnd(top: -7, end: 5),
                      isSuccess: false,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: "Go to email address",
                      isLoading: continueButtonController.isLoading,
                      onPressed: continueButtonController.isEnabled
                          ? () {
                              Navigator.popUntil(context, ModalRoute.withName(OnboardingEmailScreen.routeName));
                            }
                          : null,
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
