import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/screens/repayments/repayments_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../widgets/button.dart';

class RepaymentSuccessfullyScreenParams {
  final double fixedRate;
  final int interestRate;

  RepaymentSuccessfullyScreenParams({
    required this.fixedRate,
    required this.interestRate,
  });
}

class RepaymentSuccessfullyChangedScreen extends StatelessWidget {
  static const routeName = "/repaymentSuccessfullyChangedScreen";
  final RepaymentSuccessfullyScreenParams params;

  const RepaymentSuccessfullyChangedScreen({
    super.key,
    required this.params,
  });

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
          Text.rich(
            TextSpan(
              style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
              children: [
                const TextSpan(
                  text: 'You will start paying a fixed rate of ',
                ),
                TextSpan(
                  text: '€${params.fixedRate.toStringAsFixed(2)}',
                  style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                ),
                TextSpan(
                  text:
                      '. The ${params.interestRate}% interest rate will be calculated and added to this amount.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SvgPicture.asset(
                'assets/images/repayment_successfully_changed.svg',
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: Button(
              text: 'Back to "Repayments"',
              disabledColor: const Color(0xFFDFE2E6),
              color: ClientConfig.getColorScheme().tertiary,
              textColor: ClientConfig.getColorScheme().surface,
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
