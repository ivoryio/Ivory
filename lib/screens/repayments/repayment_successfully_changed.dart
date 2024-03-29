import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/credit_line/credit_line_action.dart';
import 'package:solarisdemo/screens/repayments/repayments_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/ivory_asset_with_badge.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../utilities/ivory_color_mapper.dart';
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
      padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
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
          if (params.interestRate >= 10) ...[
            Text.rich(
              TextSpan(
                style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                children: [
                  const TextSpan(
                    text: 'You will start paying a percentage rate of ',
                  ),
                  TextSpan(
                    text: '${params.interestRate}%',
                    style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                  ),
                  const TextSpan(
                    text: '. The 5% interest rate will be calculated and added to this amount.',
                  ),
                ],
              ),
            ),
          ],
          if (params.interestRate < 10) ...[
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
                  const TextSpan(
                    text: '. The 5% interest rate will be calculated and added to this amount.',
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          Expanded(
            child: IvoryAssetWithBadge(
              childWidget: SvgPicture(
                SvgAssetLoader(
                  'assets/images/repayment_successfully_changed.svg',
                  colorMapper: IvoryColorMapper(
                    baseColor: ClientConfig.getColorScheme().secondary,
                  ),
                ),
              ),
              childPosition: BadgePosition.topEnd(top: 24, end: 36),
              isSuccess: true,
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: Button(
              text: 'Back to "Repayments"',
              disabledColor: ClientConfig.getCustomColors().neutral300,
              color: ClientConfig.getColorScheme().tertiary,
              textColor: ClientConfig.getColorScheme().surface,
              onPressed: () {
                StoreProvider.of<AppState>(context).dispatch(GetCreditLineCommandAction());
                Navigator.popUntil(
                  context,
                  ModalRoute.withName(RepaymentsScreen.routeName),
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}
