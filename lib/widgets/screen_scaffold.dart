import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/screen_title.dart';

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
    return WillPopScope(
      onWillPop: (Platform.isIOS && shouldPop == true && popAction == null)
          ? null
          : () async {
              popAction?.call();
              return shouldPop;
            },
      child: _buildScaffold(),
    );
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
      body: Column(
        children: [
          AppToolbar(
            title: title,
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
          ),
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        ],
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

class GenericLoadingScreenBody extends StatelessWidget {
  const GenericLoadingScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppToolbar(
          padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
          actions: const [AppbarLogo()],
        ),
        const Expanded(
          child: Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}

class GenericErrorScreenBody extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTryAgainPressed;

  const GenericErrorScreenBody({
    super.key,
    this.isLoading = false,
    required this.onTryAgainPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppToolbar(
          padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
          actions: const [AppbarLogo()],
          backButtonEnabled: false,
        ),
        Expanded(
          child: Padding(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ScreenTitle("An error has occured"),
                const SizedBox(height: 16),
                Text.rich(
                  TextSpan(
                    style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                    children: [
                      const TextSpan(
                          text:
                              'We\'re sorry, but it seems an error has cropped up, which is preventing you from completing this step. Here\'s what you can do:\n\n'),
                      TextSpan(
                        text:
                            '1. Try closing the app and reopening it.\n\n2. Check your internet connection and try again.\n\n3. If the issue persists, reach out ',
                        style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                      ),
                      const TextSpan(text: 'to our friendly support team at '),
                      TextSpan(
                        text: '+49 (0)123 456789',
                        style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold.copyWith(
                            color: isLoading
                                ? ClientConfig.getCustomColors().neutral500
                                : ClientConfig.getColorScheme().secondary),
                      ),
                      const TextSpan(text: ' or '),
                      TextSpan(
                        text: 'support@ivory.com',
                        style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold.copyWith(
                            color: isLoading
                                ? ClientConfig.getCustomColors().neutral500
                                : ClientConfig.getColorScheme().secondary),
                      ),
                      const TextSpan(text: '. We\'re here to help.'),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(child: SvgPicture.asset('assets/images/general_error.svg')),
                ),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: "Try again",
                    isLoading: isLoading,
                    onPressed: isLoading ? null : onTryAgainPressed,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
