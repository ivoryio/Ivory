import 'package:flutter/material.dart';
import 'package:solarisdemo/screens/settings/settings_security_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/ivory_list_item_with_action.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/screen_title.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

import '../../config.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = "/settingsScreen";

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return ScreenScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppToolbar(
            title: "Settings",
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            scrollController: scrollController,
          ),
          Expanded(
            child: ScrollableScreenContainer(
              scrollController: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ScreenTitle(
                    "Settings",
                    padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  IvoryListItemWithAction(
                    leftIcon: Icons.person_outline,
                    actionName: 'Account',
                    actionDescription: 'Personal info & account settings',
                    rightIcon: Icons.arrow_forward_ios,
                  ),
                  IvoryListItemWithAction(
                    leftIcon: Icons.settings_outlined,
                    actionName: 'App settings',
                    actionDescription: 'Language, FaceID, notifications, etc.',
                    rightIcon: Icons.arrow_forward_ios,
                  ),
                  IvoryListItemWithAction(
                    leftIcon: Icons.security,
                    actionName: 'Security',
                    actionDescription: 'Password & device pairing',
                    rightIcon: Icons.arrow_forward_ios,
                    onPressed: () => Navigator.of(context).pushNamed(SettingsSecurityScreen.routeName),
                  ),
                  IvoryListItemWithAction(
                    leftIcon: Icons.help_outline,
                    actionName: 'Help',
                    actionDescription: 'Contact us',
                    rightIcon: Icons.arrow_forward_ios,
                  ),
                  IvoryListItemWithAction(
                    leftIcon: Icons.article_outlined,
                    actionName: 'FAQ & legal documents',
                    actionDescription: 'FAQ, T&Cs, privacy policy',
                    rightIcon: Icons.arrow_forward_ios,
                  ),
                  IvoryListItemWithAction(
                    leftIcon: Icons.logout,
                    actionName: 'Log out',
                    rightIcon: Icons.arrow_forward_ios,
                  ),
                  const Spacer(),
                  const Center(child: Text('App version 1.0')),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
