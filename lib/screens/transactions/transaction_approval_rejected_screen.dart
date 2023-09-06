import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/screens/home/home_screen.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

class TransactionApprovalRejectedScreen extends StatelessWidget {
  static const routeName = '/transactionApprovalRejectedScreen';

  const TransactionApprovalRejectedScreen({super.key});

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
            const SizedBox(height: kToolbarHeight),
            const SizedBox(height: 24),
            Text("Payment rejected!", style: ClientConfig.getTextStyleScheme().heading1),
            const SizedBox(height: 16),
            Text(
              "You rejected this payment. No money was taken from your account.",
              style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
            ),
            const Spacer(),
            Align(child: SvgPicture.asset("assets/icons/error_icon.svg")),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: "Back to \"Home\"",
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
