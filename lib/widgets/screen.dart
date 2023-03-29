import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'bottom_navbar.dart';

class Screen extends StatelessWidget {
  final Widget child;
  final String title;
  final bool hideAppBar;
  final Color? appBarColor;
  final bool? hideBackButton;
  final bool hideBottomNavbar;
  final TextStyle? titleTextStyle;
  final List<Widget>? trailingActions;

  const Screen({
    super.key,
    this.appBarColor,
    required this.child,
    required this.title,
    this.titleTextStyle,
    this.trailingActions,
    this.hideAppBar = false,
    this.hideBackButton = false,
    this.hideBottomNavbar = false,
  });

  @override
  Widget build(BuildContext context) {
    PlatformNavBar? bottomNavBar =
        hideBottomNavbar == true ? null : createBottomNavbar(context);

    PlatformAppBar? appBar = hideAppBar == true
        ? null
        : createAppBar(
            title,
            backgroundColor: appBarColor,
            hideBackButton: hideBackButton,
            titleTextStyle: titleTextStyle,
            trailingActions: trailingActions,
          );

    return PlatformScaffold(
      appBar: appBar,
      iosContentPadding: true,
      bottomNavBar: bottomNavBar,
      iosContentBottomPadding: true,
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
      iosContentPadding: true,
      appBar: createAppBar(title!),
      iosContentBottomPadding: true,
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
      iosContentPadding: true,
      appBar: createAppBar(title!),
      iosContentBottomPadding: true,
      body: Text(message!),
    );
  }
}

PlatformAppBar createAppBar(
  String title, {
  bool? hideBackButton,
  TextStyle? titleTextStyle,
  List<Widget>? trailingActions,
  Color? backgroundColor = Colors.white,
}) {
  return PlatformAppBar(
    title: Text(
      title,
      style: titleTextStyle,
    ),
    backgroundColor: backgroundColor,
    trailingActions: trailingActions,
    material: (context, platform) => MaterialAppBarData(
      elevation: 0,
    ),
    cupertino: (context, platform) => CupertinoNavigationBarData(
      border: Border.all(color: Colors.transparent),
    ),
    automaticallyImplyLeading: hideBackButton == true ? false : true,
  );
}
