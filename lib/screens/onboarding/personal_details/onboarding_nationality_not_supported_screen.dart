import 'dart:developer';

import 'package:badges/badges.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/screens/login/login_screen.dart';
import 'package:solarisdemo/utilities/ivory_color_mapper.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/ivory_asset_with_badge.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

class OnboardingNationalityNotSupportedScreen extends StatelessWidget {
  static const routeName = "/onboardingNationalityNotSupportedScreen";

  const OnboardingNationalityNotSupportedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        children: [
          AppToolbar(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
          ),
          Expanded(
            child: ScrollableScreenContainer(
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'We\'re sorry!',
                      style: ClientConfig.getTextStyleScheme().heading1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text.rich(
                    TextSpan(
                      style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                      children: [
                        const TextSpan(
                          text:
                              'Your nationality is not currently supported by our identity verification partner, and you are unable to proceed with your credit account application. For any questions or concerns you may have, please don\'t hesitate to ',
                        ),
                        TextSpan(
                          text: 'contact us',
                          recognizer: TapGestureRecognizer()..onTap = () => log('tap contact us'),
                          style: ClientConfig.getTextStyleScheme()
                              .bodyLargeRegular
                              .copyWith(color: ClientConfig.getColorScheme().secondary),
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: IvoryAssetWithBadge(
                      childWidget: SvgPicture(
                        SvgAssetLoader(
                          'assets/images/repayment_more_credit.svg',
                          colorMapper: IvoryColorMapper(
                            baseColor: ClientConfig.getColorScheme().secondary,
                          ),
                        ),
                      ),
                      childPosition: BadgePosition.topEnd(top: -5, end: 78),
                      isSuccess: false,
                    ),
                  ),
                  PrimaryButton(
                    text: "Return to \"Login Screen\"",
                    onPressed: () =>
                        Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false),
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
