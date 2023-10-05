import 'package:flutter/material.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/ivory_list_item_with_action.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/screen_title.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

import '../../config.dart';
import 'device_pairing/settings_device_pairing_screen.dart';

class SettingsSecurityScreen extends StatelessWidget {
  static const routeName = "/securitySettingsScreen";

  const SettingsSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    return ScreenScaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppToolbar(
          title: "Security",
          scrollController: scrollController,
          padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
        ),
        Expanded(
          child: ScrollableScreenContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScreenTitle(
                  "Security",
                  padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                ),
                const SizedBox(
                  height: 24,
                ),
                IvoryListItemWithAction(
                  leftIcon: Icons.phonelink_ring,
                  actionName: 'Device pairing',
                  rightIcon: Icons.arrow_forward_ios,
                  onPressed: () => Navigator.pushNamed(context, SettingsDevicePairingScreen.routeName),
                ),
                IvoryListItemWithAction(
                  leftIcon: Icons.lock_outline,
                  actionName: 'Change password',
                  rightIcon: Icons.arrow_forward_ios,
                )
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
