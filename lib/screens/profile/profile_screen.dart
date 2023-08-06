import 'package:flutter/material.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';

import '../../widgets/screen.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = "/profileScreen";

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          AppToolbar(
            title: 'Profile',
          ),
          Expanded(
            child: Center(
              child: Text('Profile'),
            ),
          ),
        ],
      ),
    );
  }
}
