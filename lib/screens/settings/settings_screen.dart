import 'package:flutter/material.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';

import '../../widgets/screen.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = "/settingsScreen";

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          AppToolbar(
            title: 'Settings',
          ),
          Expanded(
            child: Center(
              child: Text('Settings'),
            ),
          ),
        ],
      ),
    );
  }
}
