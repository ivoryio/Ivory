import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';

class ScreenScaffold extends StatelessWidget {
  final Widget body;
  final Color backgroundColor;
  final Color? statusBarColor;
  final bool extendBodyBehindAppBar;
  final Brightness statusBarIconBrightness;
  final bool shouldPop;
  final VoidCallback? popAction;

  const ScreenScaffold({
    super.key,
    this.backgroundColor = Colors.white,
    this.statusBarColor,
    this.extendBodyBehindAppBar = false,
    this.statusBarIconBrightness = Brightness.dark,
    this.shouldPop = true,
    this.popAction,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    if (shouldPop) {
      if (popAction != null) {
        return WillPopScope(
          onWillPop: () async {
            popAction!();
            return true;
          },
          child: _buildScaffold(),
        );
      } else {
        return _buildScaffold();
      }
    } else {
      return WillPopScope(onWillPop: () async => false, child: _buildScaffold());
    }
  }

  Scaffold _buildScaffold() {
    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      appBar: AppBar(
        backgroundColor: statusBarColor ?? backgroundColor,
        toolbarHeight: 0,
        elevation: 0,
        primary: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: statusBarColor ?? Colors.transparent,
          statusBarIconBrightness: statusBarIconBrightness,
          statusBarBrightness: statusBarIconBrightness == Brightness.dark ? Brightness.light : Brightness.dark,
        ),
      ),
      body: SafeArea(top: false, child: body),
    );
  }
}

class MainNavigationScreenScaffold extends StatelessWidget {
  final Widget body;
  final Color backgroundColor;
  final Color? statusBarColor;
  final bool extendBodyBehindAppBar;
  final Brightness statusBarIconBrightness;
  final BottomNavigationBar bottomNavigationBar;

  const MainNavigationScreenScaffold({
    super.key,
    this.backgroundColor = Colors.white,
    this.statusBarColor,
    this.extendBodyBehindAppBar = false,
    this.statusBarIconBrightness = Brightness.dark,
    required this.body,
    required this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      appBar: AppBar(
        backgroundColor: statusBarColor ?? backgroundColor,
        toolbarHeight: 0,
        elevation: 0,
        primary: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: statusBarColor ?? Colors.transparent,
          statusBarIconBrightness: statusBarIconBrightness,
          statusBarBrightness: statusBarIconBrightness == Brightness.dark ? Brightness.light : Brightness.dark,
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
      body: body,
    );
  }
}

class GenericLoadingScreen extends StatelessWidget {
  final String title;

  const GenericLoadingScreen({super.key, this.title = "Loading"});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            AppToolbar(title: title),
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GenericErrorScreen extends StatelessWidget {
  final String title;
  final String message;

  const GenericErrorScreen({
    super.key,
    this.title = "Error",
    this.message = "An unexpected error has occurred",
  });

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        children: [
          AppToolbar(title: title),
          Text(message),
        ],
      ),
    );
  }
}
