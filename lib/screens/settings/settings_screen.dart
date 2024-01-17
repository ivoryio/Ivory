import 'package:flutter/material.dart';
import 'package:solarisdemo/screens/settings/settings_security_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/ivory_list_tile.dart';
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
                  const IvoryListTile(
                    leftIcon: Icons.person_outline,
                    title: 'Account',
                    subtitle: 'Personal info & account settings',
                    rightIcon: Icons.arrow_forward_ios,
                  ),
                  const IvoryListTile(
                    leftIcon: Icons.settings_outlined,
                    title: 'App settings',
                    subtitle: 'Language, FaceID, notifications, etc.',
                    rightIcon: Icons.arrow_forward_ios,
                  ),
                  IvoryListTile(
                    leftIcon: Icons.security,
                    title: 'Security',
                    subtitle: 'Password & device pairing',
                    rightIcon: Icons.arrow_forward_ios,
                    onTap: () => Navigator.of(context).pushNamed(SettingsSecurityScreen.routeName),
                  ),
                  const IvoryListTile(
                    leftIcon: Icons.help_outline,
                    title: 'Help',
                    subtitle: 'Contact us',
                    rightIcon: Icons.arrow_forward_ios,
                  ),
                  const IvoryListTile(
                    leftIcon: Icons.article_outlined,
                    title: 'FAQ & legal documents',
                    subtitle: 'FAQ, T&Cs, privacy policy',
                    rightIcon: Icons.arrow_forward_ios,
                  ),
                  const IvoryListTile(
                    leftIcon: Icons.logout,
                    title: 'Log out',
                    rightIcon: Icons.arrow_forward_ios,
                  ),
                  const Spacer(),
                  const Center(child: Text('App version 2.1.0')),
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
