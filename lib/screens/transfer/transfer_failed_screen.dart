import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/screens/home/home_screen.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

class TransferFailedScreen extends StatelessWidget {
  static const routeName = "/transferFailedScreen";

  const TransferFailedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      shouldPop: false,
      body: Column(
        children: [
          Expanded(
            child: ScrollableScreenContainer(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Spacer(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Transfer failed",
                        style: ClientConfig.getTextStyleScheme().heading1,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text("transfer failed text"),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            ),
            child: Button(
              color: const Color(0xFF2575FC),
              text: "Back to \"Home\"",
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
