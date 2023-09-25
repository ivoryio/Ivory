import 'package:flutter/material.dart';

import '../config.dart';

class Screen extends StatelessWidget {
  final Widget child;
  final String? title;
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

  const Screen(
      {super.key,
      this.onRefresh,
      this.appBarColor,
      this.backButtonIcon,
      required this.child,
      this.title,
      this.titleTextStyle,
      this.trailingActions,
      this.hideAppBar = false,
      this.centerTitle = true,
      this.bottomStickyWidget,
      this.hideBackButton = false,
      this.hideBottomNavbar = false,
    this.customBackButtonCallback,
  });

  @override
  Widget build(BuildContext context) {
    AppBar? appBar = hideAppBar == true
        ? null
        : createAppBar(
            context,
            title: title ?? '',
            centerTitle: centerTitle,
            backgroundColor: appBarColor,
            hideBackButton: hideBackButton,
            titleTextStyle: titleTextStyle,
            backButtonIcon: backButtonIcon,
            trailingActions: trailingActions,
            customBackButtonCallback: customBackButtonCallback,
          );

    return Scaffold(
      appBar: appBar,
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        num bottomStickyWidgetHeight = bottomStickyWidget?.height ?? 0;

        Widget body = SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      viewportConstraints.maxHeight - bottomStickyWidgetHeight,
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
}

class LoadingScreen extends StatelessWidget {
  final String? title;

  const LoadingScreen({super.key, this.title = "Loading"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBar(context, title: title!),
      body: const Center(
        child: CircularProgressIndicator(),
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
  PreferredSizeWidget? bottom,
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

  IconButton backButton = IconButton(
    icon: backButtonIcon ?? defaultBackButtonIcon,
    padding: EdgeInsets.only(
      left: ClientConfig.getCustomClientUiSettings()
          .defaultScreenHorizontalPadding,
    ),
    alignment: Alignment.centerLeft,
    onPressed: () {
      if (customBackButtonCallback != null) {
        customBackButtonCallback();
      } else {
        if (Navigator.canPop(context)) Navigator.pop(context);
      }
    },
  );

  return AppBar(
    leading: hideBackButton == true ? null : backButton,
    title: centerTitle == true ? titleText : leftAlignedTitle,
    backgroundColor: backgroundColor,
    elevation: 0,
    centerTitle: centerTitle,
    bottom: bottom,
    actions: [
      if (trailingActions != null) ...trailingActions,
      SizedBox(
        width: ClientConfig.getCustomClientUiSettings()
            .defaultScreenHorizontalPadding,
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
