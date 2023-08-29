import 'package:flutter/material.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../config.dart';
import '../wallet/card_details_screen.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = "/settingsScreen";

  const SettingsScreen({super.key});

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
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 32,
                      height: 24 / 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  ItemName(
                    leftIcon: Icons.person_outline,
                    actionName: 'Account',
                    actionDescription: 'Personal info & account settings',
                    rightIcon: Icons.arrow_forward_ios,
                    actionSwitch: false,
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  ItemName(
                    leftIcon: Icons.settings_outlined,
                    actionName: 'App settings',
                    actionDescription: 'Language, FaceID, notifications, etc.',
                    rightIcon: Icons.arrow_forward_ios,
                    actionSwitch: false,
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  ItemName(
                    leftIcon: Icons.security,
                    actionName: 'Security',
                    actionDescription: 'Password & device pairing',
                    rightIcon: Icons.arrow_forward_ios,
                    actionSwitch: false,
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  ItemName(
                    leftIcon: Icons.help_outline,
                    actionName: 'Help',
                    actionDescription: 'Contact us',
                    rightIcon: Icons.arrow_forward_ios,
                    actionSwitch: false,
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  ItemName(
                    leftIcon: Icons.article_outlined,
                    actionName: 'FAQ & legal documents',
                    actionDescription: 'FAQ, T&Cs, privacy policy',
                    rightIcon: Icons.arrow_forward_ios,
                    actionSwitch: false,
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  ItemName(
                    leftIcon: Icons.logout,
                    actionName: 'Log out',
                    actionDescription: '',
                    rightIcon: Icons.arrow_forward_ios,
                    actionSwitch: false,
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('App version 1.0'),
                    ],
                  )
                ],
              )),
        ),
      ],
    ));
  }
}
