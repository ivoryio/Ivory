import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/models/change_request/change_request_error_type.dart';
import 'package:solarisdemo/screens/home/home_screen.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

class TransferFailedScreen extends StatelessWidget {
  static const routeName = "/transferFailedScreen";

  const TransferFailedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChangeRequestErrorType error = ModalRoute.of(context)!.settings.arguments as ChangeRequestErrorType;

    return ScreenScaffold(
      shouldPop: false,
      body: Column(
        children: [
          Expanded(
            child: ScrollableScreenContainer(
              child: Padding(
                padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Transfer failed",
                        style: ClientConfig.getTextStyleScheme().heading1,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      (error == ChangeRequestErrorType.insufficientFunds) ?
                      "Insufficient funds. You can only transfer the topped-up amount":"The transfer could not be completed.",
                      style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            child: Button(
              color: ClientConfig.getColorScheme().tertiary,
              text: "Back to \"Home\"",
              textColor: ClientConfig.getColorScheme().surface,
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
