import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

class TransactionApprovalSuccessScreen extends StatelessWidget {
  static const routeName = '/transactionApprovalSuccessScreen';

  const TransactionApprovalSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(),
            Text("Payment Authorized!\nOne more step left...", style: ClientConfig.getTextStyleScheme().heading1),
            SizedBox(height: 16),
            RichText(
              text: TextSpan(
                text: "Now you can ",
                style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                children: [
                  TextSpan(
                    text: "return to the merchant’s app or website",
                    style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                  ),
                  TextSpan(text: " you ordered from and complete the checkout.")
                ],
              ),
            ),
            Spacer(),
            Align(child: SvgPicture.asset("assets/images/transaction_approved_illustration.svg")),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: "OK, I understand",
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
