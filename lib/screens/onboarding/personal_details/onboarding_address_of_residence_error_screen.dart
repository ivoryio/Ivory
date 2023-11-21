import 'package:badges/badges.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/screens/login/login_screen.dart';
import 'package:solarisdemo/utilities/ivory_color_mapper.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/ivory_asset_with_badge.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/screen_title.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

class OnboardingAddressOfResidenceErrorScreen extends StatelessWidget {
  static const routeName = "/nnboardingAddressOfResidenceErrorScreen";

  const OnboardingAddressOfResidenceErrorScreen({super.key});

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
                  const ScreenTitle("We're sorry!"),
                  const SizedBox(height: 16),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: "At the moment, "),
                        TextSpan(
                          text: "German residency is required ",
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                        ),
                        const TextSpan(text: "to proceed with your credit account application. ")
                      ],
                      style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: "For any questions or concerns you may have, please don't hesitate to "),
                        TextSpan(
                          text: "contact us",
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold.copyWith(
                                color: ClientConfig.getColorScheme().secondary,
                              ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print("tap: contact us");
                            },
                        ),
                        const TextSpan(text: ".")
                      ],
                      style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
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
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: "Return to \"Login Screen\"",
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context,
                        LoginScreen.routeName,
                        (route) => false,
                      ),
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
