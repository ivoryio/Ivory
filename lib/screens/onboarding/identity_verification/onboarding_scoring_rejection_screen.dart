import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/screens/welcome/welcome_screen.dart';
import 'package:solarisdemo/utilities/ivory_color_mapper.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/ivory_asset_with_badge.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

class OnboardingScoringRejectionScreen extends StatelessWidget {
  static const routeName = "/onboardingScoringRejectionScreen";

  const OnboardingScoringRejectionScreen({super.key});

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
                    'Your score has been rejected',
                    style: ClientConfig.getTextStyleScheme().heading1,
                  ),
                  const SizedBox(height: 16),
                  Text.rich(
                    TextSpan(
                      style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                      children: [
                        const TextSpan(
                          text:
                              "We regret to inform you that your scoring application has been rejected. We understand this may be disappointing, and we're here to assist you. \n\n",
                        ),
                        const TextSpan(
                          text: "For any questions or concerns you may have, please don't hesitate to ",
                        ),
                        TextSpan(
                          text: 'contact us',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              debugPrint("Contact us tapped");
                            },
                          style: ClientConfig.getTextStyleScheme()
                              .bodyLargeRegularBold
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
                    text: "Return to “Welcome Screen”",
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, WelcomeScreen.routeName, (route) => false);
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
