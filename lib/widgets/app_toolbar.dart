import 'package:flutter/material.dart';

class AppToolbar extends StatelessWidget {
  final Color backgroundColor;
  final EdgeInsets? padding;
  final Icon backIcon;
  final List<Widget> actions;
  final RichText? richTextTitle;
  final String title;
  final bool backButtonEnabled;
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
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding != null ? padding! : EdgeInsets.zero,
      child: AppBar(
        actions: actions,
        automaticallyImplyLeading: false,
        backgroundColor: backgroundColor,
        centerTitle: true,
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
