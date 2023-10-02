import 'dart:math';

import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';

class AppToolbar extends StatefulWidget {
  final String title;
  final Icon backIcon;
  final Widget? bottom;
  final EdgeInsets? padding;
  final List<Widget> actions;
  final Color backgroundColor;
  final double? toolbarHeight;
  final bool backButtonEnabled;
  final RichText? richTextTitle;
  final double titleMaxOpacityScrollOffset;
  final ScrollController? scrollController;
  final void Function()? onBackButtonPressed;

  const AppToolbar({
    super.key,
    this.bottom,
    this.padding,
    this.title = "",
    this.richTextTitle,
    this.toolbarHeight,
    this.actions = const [],
    this.onBackButtonPressed,
    this.backButtonEnabled = true,
    this.scrollController,
    this.titleMaxOpacityScrollOffset = 100,
    this.backgroundColor = Colors.white,
    this.backIcon = const Icon(Icons.arrow_back),
  });

  @override
  State<AppToolbar> createState() => _AppToolbarState();
}

class _AppToolbarState extends State<AppToolbar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.scrollController == null) return _buildAppToolbar(context, titleOpacity: 1.0);

    if (widget.scrollController!.hasClients == false) {
      return _buildAppToolbar(context, titleOpacity: 0.0);
    }

    return AnimatedBuilder(
      animation: widget.scrollController!,
      builder: (controller, child) {
        final offset = widget.scrollController!.offset;
        final titleOpacity = max(0, min(1, offset / widget.titleMaxOpacityScrollOffset)).toDouble();

        return _buildAppToolbar(context, titleOpacity: titleOpacity);
      },
    );
  }

  Widget _buildAppToolbar(
    BuildContext context, {
    required double titleOpacity,
  }) {
    return Container(
      padding: widget.padding ?? ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        boxShadow: [
          if (widget.scrollController != null)
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5 * titleOpacity,
              offset: Offset(0, 3 * titleOpacity),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            actions: widget.actions,
            automaticallyImplyLeading: false,
            backgroundColor: widget.backgroundColor,
            centerTitle: true,
            toolbarHeight: widget.toolbarHeight,
            elevation: 0,
            leadingWidth: 25,
            leading: (widget.backButtonEnabled && Navigator.canPop(context))
                ? InkWell(
                    onTap: widget.onBackButtonPressed ?? () => Navigator.of(context).pop(),
                    child: widget.backIcon,
                  )
                : null,
            title: Opacity(
              opacity: titleOpacity,
              child: widget.richTextTitle ?? Text(widget.title),
            ),
            titleSpacing: 8,
          ),
          if (widget.bottom != null) widget.bottom!,
        ],
      ),
    );
  }
}
