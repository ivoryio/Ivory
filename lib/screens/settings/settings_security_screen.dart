import 'package:flutter/material.dart';
import 'package:solarisdemo/screens/settings/settings_device_pairing_screen.dart';
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Security',
                    style: TextStyle(
                      fontSize: 32,
                      height: 24 / 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  IvoryActionItem(
                    leftIcon: Icons.phonelink_ring,
                    actionName: 'Device pairing',
                    rightIcon: Icons.arrow_forward_ios,
                    actionSwitch: false,
                    onPressed: () => Navigator.pushNamed(context, SettingsDevicePairingScreen.routeName),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  const IvoryActionItem(
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
