import 'package:flutter/material.dart';

import '../../config.dart';
import '../../widgets/screen.dart';

class AccountDetailsScreen extends StatelessWidget {
  const AccountDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Screen(
        scrollPhysics: const NeverScrollableScrollPhysics(),
        title: 'Account Details',
        centerTitle: true,
        hideBackButton: true,
        hideBottomNavbar: false,
        child: Padding(
          padding:
              ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
          child: const Text('Account Details'),
        ));
  }
}
