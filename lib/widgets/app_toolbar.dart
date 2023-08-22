import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';

class AppToolbar extends StatelessWidget {
  final Color backgroundColor;
  final EdgeInsets? padding;
  final Icon backIcon;
  final List<Widget> actions;
  final RichText? richTextTitle;
  final String title;
  final bool backButtonEnabled;
  final double? toolbarHeight;
  final void Function()? onBackButtonPressed;

  const AppToolbar({
    super.key,
    this.actions = const [],
    this.backButtonEnabled = true,
    this.backIcon = const Icon(Icons.arrow_back),
    this.backgroundColor = Colors.transparent,
    this.onBackButtonPressed,
    this.padding,
    this.richTextTitle,
    this.title = "",
    this.toolbarHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding != null
          ? padding!
          : EdgeInsets.symmetric(horizontal: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding),
      color: backgroundColor,
      child: AppBar(
        actions: actions,
        automaticallyImplyLeading: false,
        backgroundColor: backgroundColor,
        centerTitle: true,
        toolbarHeight: toolbarHeight,
        elevation: 0,
        leadingWidth: 25,
        leading: (backButtonEnabled && Navigator.canPop(context))
            ? InkWell(
                onTap: onBackButtonPressed ?? () => Navigator.of(context).pop(),
                child: backIcon,
              )
            : null,
        title: richTextTitle ?? Text(title),
        titleSpacing: 8,
      ),
    );
  }
}
