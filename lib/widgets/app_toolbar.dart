import 'package:flutter/material.dart';

class AppToolbar extends StatelessWidget {
  final EdgeInsets? padding;
  final String title;
  final Icon backIcon;
  final List<Widget> actions;
  final RichText? richTextTitle;
  final Color backgroundColor;
  final bool backButtonEnabled;
  final void Function()? onBackButtonPressed;

  const AppToolbar({
    super.key,
    this.title = "",
    this.richTextTitle,
    this.backIcon = const Icon(Icons.arrow_back),
    this.padding,
    this.actions = const [],
    this.backgroundColor = Colors.transparent,
    this.backButtonEnabled = true,
    this.onBackButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding != null ? padding! : EdgeInsets.zero,
      child: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: richTextTitle ?? Text(title),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leadingWidth: 25,
        titleSpacing: 8,
        leading: (backButtonEnabled && Navigator.canPop(context))
            ? InkWell(
                onTap: onBackButtonPressed ?? () => Navigator.of(context).pop(),
                child: backIcon,
              )
            : null,
        actions: actions,
      ),
    );
  }
}
