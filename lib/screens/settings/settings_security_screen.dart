import 'package:flutter/material.dart';
import 'package:solarisdemo/screens/wallet/card_details_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../config.dart';

class SettingsSecurityScreen extends StatelessWidget {
  static const routeName = "/securitySettingsScreen";

  const SettingsSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppToolbar(
          padding: EdgeInsets.symmetric(
            horizontal: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
          ),
        ),
        Expanded(
          child: Padding(
              padding: EdgeInsets.only(
                left: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                right: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                bottom: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Security',
                    style: TextStyle(
                      fontSize: 32,
                      height: 24 / 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  IvoryActionItem(
                    leftIcon: Icons.phonelink_ring,
                    actionName: 'Device pairing',
                    rightIcon: Icons.arrow_forward_ios,
                    actionSwitch: false,
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  IvoryActionItem(
                    leftIcon: Icons.lock_outline,
                    actionName: 'Change password',
                    rightIcon: Icons.arrow_forward_ios,
                    actionSwitch: false,
                  )
                ],
              )),
        ),
      ],
    ));
  }
}
