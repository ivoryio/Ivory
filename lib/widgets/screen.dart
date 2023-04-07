import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:solarisdemo/themes/default_theme.dart';

import '../router/router.dart';

class Screen extends StatelessWidget {
  final Widget child;
  final String title;
  final bool hideAppBar;
  final Color? appBarColor;
  final bool? hideBackButton;
  final bool hideBottomNavbar;
  final TextStyle? titleTextStyle;
  final List<Widget>? trailingActions;
  final bool? centerTitle;
  final Widget? bottomStickyWidget;
  final num bottomStickyWidgetHeight;

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
    this.centerTitle = true,
    this.bottomStickyWidget,
    this.bottomStickyWidgetHeight = 120,
  });

  @override
  Widget build(BuildContext context) {
    PlatformAppBar? appBar = hideAppBar == true
        ? null
        : createAppBar(
            title,
            backgroundColor: appBarColor,
            hideBackButton: hideBackButton,
            titleTextStyle: titleTextStyle,
            trailingActions: trailingActions,
            centerTitle: centerTitle,
          );

    int currentPageIndex = AppRouter.calculateSelectedIndex(context);

    PlatformTabController tabController = PlatformTabController(
      initialIndex: currentPageIndex,
    );

    if (hideBottomNavbar) {
      return PlatformScaffold(
        appBar: appBar,
        iosContentPadding: true,
        iosContentBottomPadding: true,
        body: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          num heightToSubstract =
              (bottomStickyWidget != null) ? bottomStickyWidgetHeight : 0;

          Widget screenContent = SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight - heightToSubstract,
              ),
              child: IntrinsicHeight(
                child: child,
              ),
            ),
          );

          return Column(children: [
            Expanded(child: screenContent),
            if (bottomStickyWidget != null)
              Container(
                height: bottomStickyWidgetHeight.toDouble(),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      spreadRadius: 0,
                      blurRadius: 12,
                      offset: const Offset(0, -4), // changes position of shadow
                    ),
                  ],
                ),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: bottomStickyWidget,
                ),
              )
          ]);
        }),
      );
    }

    return PlatformTabScaffold(
      iosContentPadding: true,
      tabController: tabController,
      iosContentBottomPadding: true,
      appBarBuilder: (context, index) => appBar,
      itemChanged: (pageIndex) {
        if (currentPageIndex != pageIndex) {
          AppRouter.navigateToPage(pageIndex, context);
        }
      },
      materialTabs: (context, platform) => MaterialNavBarData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      cupertinoTabs: (context, platform) => CupertinoTabBarData(
        backgroundColor: Colors.white,
        activeColor: Colors.black,
        inactiveColor: Colors.grey,
      ),
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
      bodyBuilder: (context, index) => LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: child,
          ),
        );
      }),
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
  bool? centerTitle = true,
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
      centerTitle: centerTitle,
    ),
    cupertino: (context, platform) => CupertinoNavigationBarData(
      border: Border.all(color: Colors.transparent),
    ),
    automaticallyImplyLeading: hideBackButton == true ? false : true,
  );
}
