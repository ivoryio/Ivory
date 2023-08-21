import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';

import '../../config.dart';
import '../../widgets/button_with_icon.dart';
import '../../widgets/screen_scaffold.dart';
import '../../widgets/spaced_column.dart';
import 'card_details_activation_success_screen.dart';

class BankCardDetailsAppleWalletScreen extends StatelessWidget {
  static const routeName = '/bankCardDetailsAppleWalletScreen';

  const BankCardDetailsAppleWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppToolbar(
            richTextTitle: RichText(
                text: const TextSpan(
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Step 4 ',
                  style: TextStyle(color: Color(0xFF15141E)),
                ),
                TextSpan(
                  text: 'out of 4',
                  style: TextStyle(color: Color(0xFF56555E)),
                ),
              ],
            )),
            padding: EdgeInsets.symmetric(
              horizontal: ClientConfig.getCustomClientUiSettings()
                  .defaultScreenHorizontalPadding,
            ),
            backButtonEnabled: true, //needs to be false
          ),
          const LinearProgressIndicator(
            value: 4 / 4,
            color: Color(0xFF2575FC),
            backgroundColor: Color(0xFFE9EAEB),
          ),
          Expanded(
            child: Padding(
              padding:
                  ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
              child: Column(
                children: [
                  const Text(
                    'Add your credit card to Apple Wallet',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      height: 32 / 24,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Add your Porsche credit card to Apple Wallet to start making seamless POS purchases.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 24 / 16,
                    ),
                  ),
                  const SizedBox(
                    height: 160,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/images/apple_wallet_logo.svg')
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Button(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 23.0),
                          text: 'Maybe later',
                          textStyle: const TextStyle(
                            color: Color(0xFF2575FC),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              BankCardDetailsActivationSuccessScreen.routeName,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      ButtonWithIcon(
                        text: 'Add to Apple Wallet',
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        onPressed: () {
                          //TODO: Add to apple wallet flow
                        },
                        iconWidget:
                            Image.asset('assets/icons/apple_wallet_logo.png'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
