import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/screens/home/home_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../utilities/ivory_color_mapper.dart';

class TransactionApprovalSuccessScreen extends StatelessWidget {
  static const routeName = '/transactionApprovalSuccessScreen';

  const TransactionApprovalSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Padding(
        padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppToolbar(),
            Text("Payment Authorized!\nOne more step left...", style: ClientConfig.getTextStyleScheme().heading1),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                text: "Now you can ",
                style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                children: [
                  TextSpan(
                    text: "return to the merchant's app or website",
                    style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                  ),
                  const TextSpan(text: " you ordered from and complete the checkout.")
                ],
              ),
            ),
            const Spacer(),
            Align(child: SvgPicture(
              SvgAssetLoader(
                "assets/images/transaction_approved_illustration.svg",
                colorMapper: IvoryColorMapper(baseColor: ClientConfig.getColorScheme().secondary,),
              ),
            ),),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: "OK, I understand",
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
