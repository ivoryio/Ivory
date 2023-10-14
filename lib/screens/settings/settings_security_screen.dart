import 'package:flutter/material.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/ivory_list_tile.dart';
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
                IvoryListTile(
                  leftIcon: Icons.phonelink_ring,
                  title: 'Device pairing',
                  rightIcon: Icons.arrow_forward_ios,
                  onTap: () => Navigator.pushNamed(context, SettingsDevicePairingScreen.routeName),
                ),
                const IvoryListTile(
                  leftIcon: Icons.lock_outline,
                  title: 'Change password',
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
