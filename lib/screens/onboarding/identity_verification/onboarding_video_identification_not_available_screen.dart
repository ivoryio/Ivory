import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/utilities/ivory_color_mapper.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/ivory_asset_with_badge.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

class OnboardingVideoIdentificationNotAvailableScreen extends StatelessWidget {
  static const routeName = "/onboardingVideoIdentificationNotAvailableScreen";

  const OnboardingVideoIdentificationNotAvailableScreen({super.key});

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Video identification is not available yet',
                    style: ClientConfig.getTextStyleScheme().heading1,
                  ),
                  const SizedBox(height: 16),
                  Text.rich(
                    TextSpan(
                      style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                      children: [
                        TextSpan(
                          text: 'Video identification is supported by Solaris',
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                        ),
                        const TextSpan(
                          text:
                              ', but it\'s not currently our top priority for implementation. Please go back and proceed by selecting ',
                        ),
                        TextSpan(
                          text: '“Bank identification”',
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                        ),
                        TextSpan(text: '. Thank you for your understanding!'),
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
                    text: "Go back",
                    onPressed: () {
                      Navigator.pop(context);
                    },
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
