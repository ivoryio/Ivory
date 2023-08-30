import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/screens/home/home_screen.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

class TransactionApprovalFailedScreen extends StatelessWidget {
  static const routeName = '/transactionApprovalFailedScreen';

  const TransactionApprovalFailedScreen({super.key});

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
            Text("Online payment was unsuccessful!", style: ClientConfig.getTextStyleScheme().heading1),
            SizedBox(height: 16),
            Text(
              "Due to a technical issue, your online payment was unsuccessful. Please try again.",
              style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
            ),
            Spacer(),
            Align(child: SvgPicture.asset("assets/icons/error_icon.svg")),
            Spacer(),
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
