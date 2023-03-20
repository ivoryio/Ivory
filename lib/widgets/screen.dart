import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'bottom_navbar.dart';

class Screen extends StatelessWidget {
  final Widget child;
  final String title;
  final bool hideBottomNavbar;
  final bool hideAppBar;

  const Screen({
    super.key,
    required this.child,
    required this.title,
    this.hideBottomNavbar = false,
    this.hideAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      iosContentBottomPadding: true,
      iosContentPadding: true,
      appBar: hideAppBar == true
          ? null
          : PlatformAppBar(
              title: Text(
                title,
              ),
              cupertino: (context, platform) => CupertinoNavigationBarData(
                border: Border.all(color: Colors.transparent),
              ),
              backgroundColor: Colors.white,
            ),
      bottomNavBar:
          hideBottomNavbar == true ? null : createBottomNavbar(context),
      body: child,
    );
  }
}
