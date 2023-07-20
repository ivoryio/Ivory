import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';

import '../router/router.dart';
import '../themes/default_theme.dart';
import '../router/routing_constants.dart';

class Screen extends StatelessWidget {
  final Widget child;
  final String title;
  final bool hideAppBar;
  final bool? centerTitle;
  final Color? appBarColor;
  final bool? hideBackButton;
  final Icon? backButtonIcon;
  final bool hideBottomNavbar;
  final TextStyle? titleTextStyle;
  final List<Widget>? trailingActions;
  final Future<void> Function()? onRefresh;
  final Function? customBackButtonCallback;
  final BottomStickyWidget? bottomStickyWidget;
  final ScrollPhysics? scrollPhysics;

  const Screen({
    super.key,
    this.onRefresh,
    this.appBarColor,
    this.backButtonIcon,
    required this.child,
    required this.title,
    this.titleTextStyle,
    this.trailingActions,
    this.hideAppBar = false,
    this.centerTitle = true,
    this.bottomStickyWidget,
    this.hideBackButton = false,
    this.hideBottomNavbar = false,
    this.customBackButtonCallback,
    this.scrollPhysics,
  });

  @override
  Widget build(BuildContext context) {
    AppBar? appBar = hideAppBar == true
        ? null
        : createAppBar(
            context,
            title: title,
            centerTitle: centerTitle,
            backgroundColor: appBarColor,
            hideBackButton: hideBackButton,
            titleTextStyle: titleTextStyle,
            backButtonIcon: backButtonIcon,
            trailingActions: trailingActions,
            customBackButtonCallback: customBackButtonCallback,
          );

    int currentPageIndex = AppRouter.calculateSelectedIndex(context);

    ScrollPhysics? physics = onRefresh != null
        ? scrollPhysics ?? const AlwaysScrollableScrollPhysics()
        : null;

    if (hideBottomNavbar) {
      return Scaffold(
        appBar: appBar,
        body: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          num bottomStickyWidgetHeight = bottomStickyWidget?.height ?? 0;

          Widget body = SingleChildScrollView(
            physics: physics,
            child: Column(
              children: [
                const LinearProgressIndicator(
                  value: 1 / 4,
                  color: Color(0xFFCC0000),
                  backgroundColor: Color(0xFFE9EAEB),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight -
                        bottomStickyWidgetHeight,
                  ),
                  child: IntrinsicHeight(child: child),
                ),
              ],
            ),
          );

          Widget screenContent = Column(children: [
            Expanded(child: body),
            if (bottomStickyWidget != null) bottomStickyWidget!.build(context)
          ]);

          if (onRefresh != null) {
            return RefreshIndicator(
              onRefresh: onRefresh!,
              child: screenContent,
            );
          }

          return screenContent;
        }),
      );
    }

    return Scaffold(
      appBar: appBar,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          Widget screenContent = SingleChildScrollView(
            physics: physics,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: child,
            ),
          );

          return LayoutBuilder(builder: (context, constraints) {
            if (onRefresh != null) {
              return RefreshIndicator(
                onRefresh: onRefresh!,
                child: screenContent,
              );
            }

            return screenContent;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPageIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 0,
        onTap: (index) {
          if (currentPageIndex != index) {
            AppRouter.navigateToPage(index, context);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_card),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payments),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  final String? title;
  const LoadingScreen({super.key, this.title = "Loading"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBar(context, title: title!),
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
    return Scaffold(
      appBar: createAppBar(context, title: title!),
      body: Text(message!),
    );
  }
}

AppBar createAppBar(
  BuildContext context, {
  bool? hideBackButton,
  Icon? backButtonIcon,
  required String title,
  bool? centerTitle = true,
  TextStyle? titleTextStyle,
  List<Widget>? trailingActions,
  Function? customBackButtonCallback,
  Color? backgroundColor = Colors.white,
}) {
  Text titleText = Text(
    title,
    style: titleTextStyle,
  );

  Icon defaultBackButtonIcon = const Icon(
    Icons.arrow_back_ios,
    color: Colors.black,
  );

  Widget leftAlignedTitle = Container(
    width: double.infinity,
    padding: const EdgeInsets.only(left: 16),
    child: titleText,
  );

  PlatformIconButton backButton = PlatformIconButton(
    padding: EdgeInsets.zero,
    icon: backButtonIcon ?? defaultBackButtonIcon,
    material: (context, platform) => MaterialIconButtonData(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: defaultScreenHorizontalPadding),
    ),
    onPressed: () {
      if (customBackButtonCallback != null) {
        customBackButtonCallback();
      } else {
        if (context.canPop()) return context.pop();

        context.go(homeRoute.path);
      }
    },
  );

  return AppBar(
    leading: hideBackButton == true ? null : backButton,
    title: centerTitle == true ? titleText : leftAlignedTitle,
    backgroundColor: backgroundColor,
    elevation: 0,
    centerTitle: centerTitle,
    actions: [
      if (trailingActions != null) ...trailingActions,
      const SizedBox(
        width: defaultScreenHorizontalPadding,
      )
    ],
    automaticallyImplyLeading: hideBackButton == true ? false : true,
  );
}

class BottomStickyWidget extends StatelessWidget {
  final Widget child;
  final num height;

  const BottomStickyWidget({
    super.key,
    this.height = 100,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.toDouble(),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, -4),
            color: Colors.black.withOpacity(0.25),
          ),
        ],
      ),
      child: Container(
        alignment: Alignment.topLeft,
        child: child,
      ),
    );
  }
}
