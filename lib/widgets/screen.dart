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
              material: (context, platform) => MaterialAppBarData(
                elevation: 0,
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

class LoadingScreen extends StatelessWidget {
  final String? title;
  const LoadingScreen({super.key, this.title = "Loading"});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      iosContentBottomPadding: true,
      iosContentPadding: true,
      appBar: PlatformAppBar(
        title: Text(
          title!,
        ),
        material: (context, platform) => MaterialAppBarData(
          elevation: 0,
        ),
        cupertino: (context, platform) => CupertinoNavigationBarData(
          border: Border.all(color: Colors.transparent),
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: PlatformCircularProgressIndicator(),
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final String? title;
  final String? message;
  const ErrorScreen(
      {super.key,
      this.title = "Error",
      this.message = "An unexpected error has occured"});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      iosContentBottomPadding: true,
      iosContentPadding: true,
      appBar: PlatformAppBar(
        title: Text(
          title!,
        ),
        material: (context, platform) => MaterialAppBarData(
          elevation: 0,
        ),
        cupertino: (context, platform) => CupertinoNavigationBarData(
          border: Border.all(color: Colors.transparent),
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Text(message!),
      ),
    );
  }
}
