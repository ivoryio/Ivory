import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'bottom_navbar.dart';

class Screen extends StatelessWidget {
  final Widget child;
  final String title;
  final bool hideBottomNavbar;
  final bool hideAppBar;
  final List<Widget>? trailingActions;
  final bool? hideBackButton;
  final Color? appBarColor;
  final TextStyle? titleTextStyle;

  const Screen({
    super.key,
    required this.child,
    required this.title,
    this.hideBottomNavbar = false,
    this.hideAppBar = false,
    this.trailingActions,
    this.hideBackButton = false,
    this.appBarColor,
    this.titleTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    PlatformNavBar? bottomNavBar =
        hideBottomNavbar == true ? null : createBottomNavbar(context);

    PlatformAppBar? appBar = hideAppBar == true
        ? null
        : createAppBar(
            title,
            trailingActions: trailingActions,
            hideBackButton: hideBackButton,
            backgroundColor: appBarColor,
            titleTextStyle: titleTextStyle,
          );

    return PlatformScaffold(
      iosContentBottomPadding: true,
      iosContentPadding: true,
      appBar: appBar,
      bottomNavBar: bottomNavBar,
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
      appBar: createAppBar(title!),
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
      appBar: createAppBar(title!),
      body: Text(message!),
    );
  }
}

PlatformAppBar createAppBar(
  String title, {
  List<Widget>? trailingActions,
  bool? hideBackButton,
  Color? backgroundColor = Colors.white,
  TextStyle? titleTextStyle,
}) {
  return PlatformAppBar(
    title: Text(
      title,
      style: titleTextStyle,
    ),
    material: (context, platform) => MaterialAppBarData(
      elevation: 0,
    ),
    cupertino: (context, platform) => CupertinoNavigationBarData(
      border: Border.all(color: Colors.transparent),
    ),
    backgroundColor: backgroundColor,
    trailingActions: trailingActions,
    automaticallyImplyLeading: hideBackButton == true ? false : true,
  );
}
