import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/screens/repayments/repayments_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../widgets/button.dart';

class RepaymentSuccessfullyChanged extends StatelessWidget {
  static const routeName = "/repaymentSuccessfullyChangedScreen";

  const RepaymentSuccessfullyChanged({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ClientConfig.getCustomClientUiSettings()
              .defaultScreenHorizontalPadding),
      child: Column(
        children: [
          const AppToolbar(
            backButtonEnabled: false,
          ),
          Text(
            'Repayment successfully changed!',
            style: ClientConfig.getTextStyleScheme().heading1,
          ),
          const SizedBox(height: 16),
          Text(
            'You will start paying a fixed rate of €500.00. The 5% interest rate will be calculated and added to this amount.',
            style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SvgPicture.asset(
                'assets/images/repayment_successfully_changed.svg'),
          ),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: Button(
              text: 'Back to "Repayments"',
              disabledColor: const Color(0xFFDFE2E6),
              color: const Color(0xFF2575FC),
              onPressed: () {
                Navigator.popUntil(
                  context,
                  ModalRoute.withName(RepaymentsScreen.routeName),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    ));
  }
}
