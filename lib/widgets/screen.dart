import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'bottom_navbar.dart';

class Screen extends StatelessWidget {
  final Widget child;
  final String title;
  final bool hideBottomNavbar;

  const Screen({
    super.key,
    required this.child,
    required this.title,
    this.hideBottomNavbar = false,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      iosContentBottomPadding: true,
      iosContentPadding: true,
      appBar: PlatformAppBar(
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
