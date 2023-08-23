import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/screens/wallet/card_details_choose_pin.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';

import '../../config.dart';
import '../../widgets/button.dart';
import '../../widgets/screen_scaffold.dart';

class BankCardDetailsInfoScreen extends StatelessWidget {
  static const routeName = '/cardDetailsInfoScreen';

  const BankCardDetailsInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  text: 'Step 1 ',
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
            backButtonEnabled: true,
            onBackButtonPressed: () {
              Navigator.pop(
                context,
              );
            },
          ),
          const LinearProgressIndicator(
            value: 1 / 3,
            color: Color(0xFF2575FC),
            backgroundColor: Color(0xFFE9EAEB),
          ),
          Expanded(
            child: Padding(
              padding:
                  ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Activate your physical card',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      height: 1.33,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'In order to activate your physical card you will have to choose a PIN and confirm it. You can also add it to your Apple Wallet. \n\nIt\'ll take only 1 minute.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/images/choose_pin.svg',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Button(
                      text: "Choose PIN",
                      disabledColor: const Color(0xFFDFE2E6),
                      color: const Color(0xFF2575FC),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          BankCardDetailsChoosePinScreen.routeName,
                        );
                      },
                    ),
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
