import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/utilities/ivory_color_mapper.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/ivory_asset_with_badge.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

class OnboardingAllowNotificationsSuccessScreen extends StatelessWidget {
  static const routeName = "/onboardingAllowNotificationsSuccessScreen";

  const OnboardingAllowNotificationsSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        children: [
          AppToolbar(
            richTextTitle: StepRichTextTitle(step: 4, totalSteps: 5),
            actions: const [AppbarLogo()],
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
          ),
          LinearProgressIndicator(
            value: 3 / 5,
            color: ClientConfig.getColorScheme().secondary,
            backgroundColor: ClientConfig.getCustomColors().neutral200,
          ),
          Expanded(
            child: ScrollableScreenContainer(
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    "Instant notifications on all account activity",
                    style: ClientConfig.getTextStyleScheme().heading2,
                  ),
                  const SizedBox(height: 16),
                  Text("Thank you! We will notify you about every account acitivity.",
                      style: ClientConfig.getTextStyleScheme().bodyLargeRegular),
                  Expanded(
                    child: IvoryAssetWithBadge(
                      isSuccess: true,
                      childPosition: BadgePosition.topStart(start: -5, top: -30),
                      childWidget: SvgPicture(
                        SvgAssetLoader(
                          'assets/images/notifications_illustration.svg',
                          colorMapper: IvoryColorMapper(
                            baseColor: ClientConfig.getColorScheme().secondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  PrimaryButton(
                    text: "Continue",
                    onPressed: () {},
                  ),
                  const SizedBox(height: 16)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
