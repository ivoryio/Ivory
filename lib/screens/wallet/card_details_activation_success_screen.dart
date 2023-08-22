import 'package:flutter/material.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../config.dart';
import '../../widgets/button.dart';
import '../../widgets/card_widget.dart';
import 'cards_screen.dart';

class BankCardDetailsActivationSuccessScreen extends StatelessWidget {
  static const routeName = '/bankCardDetailsActivationSuccessScreen';

  const BankCardDetailsActivationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
        body: Padding(
      padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const AppToolbar(
            backButtonEnabled: false,
          ),
          const Text(
            'Physical card successfully activated!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'You can now start using your PIN to make in-store purchases, make withdrawals and more.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
          const Spacer(),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BankCardWidget(
                isCardEmpty: true,
                customHeight: 148,
                customWidth: 231,
                isViewable: false,
              ),
            ],
          ),
          const SizedBox(
            height: 124,
          ),
          SizedBox(
            width: double.infinity,
            child: Button(
              disabledColor: const Color(0xFFDFE2E6),
              color: const Color(0xFF2575FC),
              text: 'Back to "Card"',
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  BankCardsScreen.routeName,
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}
