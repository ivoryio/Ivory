import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/screens/transfer/transfer_successful_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/tan_input.dart';

class TransferSignScreen extends StatelessWidget {
  static const routeName = "/transferSignScreen";

  const TransferSignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      shouldPop: false,
      body: Column(
        children: [
          AppToolbar(
            padding: EdgeInsets.symmetric(
              horizontal: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Confirm OTP",
                    style: ClientConfig.getTextStyleScheme().heading1,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Please enter the OTP sent to your registered mobile number",
                    style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 16),
                  TanInput(
                    length: 6,
                    onCompleted: (tan) {
                      Navigator.pushNamed(context, TransferSuccessfulScreen.routeName);
                    },
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
