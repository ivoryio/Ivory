import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/utilities/ivory_color_mapper.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/ivory_asset_with_badge.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/screen_title.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

class OnboardingIdentityVerificationErrorScreen extends StatelessWidget {
  static const routeName = "/onboardingIdentityVerificationErrorScreen";

  const OnboardingIdentityVerificationErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: ScrollableScreenContainer(
        padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppToolbar(),
            const ScreenTitle("Your identity verification has failed"),
            const SizedBox(height: 16),
            Text.rich(
              TextSpan(
                style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                children: [
                  const TextSpan(text: 'We regret to inform you that your '),
                  TextSpan(
                    text: 'identity verification ',
                    style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                  ),
                  const TextSpan(text: 'has not been successful due to a '),
                  TextSpan(
                    text: 'technical issue',
                    style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                  ),
                  const TextSpan(text: '.\n\n'),
                  const TextSpan(text: 'Please get in touch with us by tapping on the '),
                  TextSpan(
                    text: 'button below',
                    style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
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
              text: "Contact us",
              onPressed: () {},
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
