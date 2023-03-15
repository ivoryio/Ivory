import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../router/router.dart';
import 'bottom_navbar.dart';

class Screen extends StatelessWidget {
  final Widget child;
  final String title;

  const Screen({
    super.key,
    required this.child,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      iosContentBottomPadding: true,
      iosContentPadding: true,
      appBar: PlatformAppBar(
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1C1A28),
      ),
      bottomNavBar: createBottomNavbar(context),
      body: child,
    );
  }
}
