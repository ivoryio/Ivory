import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/utilities/ivory_color_mapper.dart';
import 'package:solarisdemo/widgets/ivory_asset_with_badge.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../../config.dart';
import '../../../widgets/app_toolbar.dart';
import '../../../widgets/button.dart';

class MoreCreditWaitlistScreen extends StatelessWidget {
  static const routeName = "/repaymentMoreCreditWaitlist";

  const MoreCreditWaitlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Padding(
        padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppToolbar(),
            Text(
              'You have been successfully added to the waitlist',
              style: ClientConfig.getTextStyleScheme().heading1,
            ),
            const SizedBox(height: 16),
            Text(
              'When we introduce support for credit increases, we will notify you through a push notification and/or email. Thank you!',
              style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
            ),
            const SizedBox(height: 24),
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
                isSuccess: true,
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: Button(
                text: 'Back to “Repayments”',
                disabledColor: const Color(0xFFDFE2E6),
                color: ClientConfig.getColorScheme().tertiary,
                textColor: ClientConfig.getColorScheme().surface,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
