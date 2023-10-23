import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';

import 'button.dart';

const int _defaultSelectedTabIndex = 0;

class TabView extends StatefulWidget {
  final List<TabViewItem> tabs;
  final int? initialSelectedTabIndex;

  const TabView({
    super.key,
    required this.tabs,
    this.initialSelectedTabIndex,
  });

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  int selectedTab = _defaultSelectedTabIndex;

  @override
  void initState() {
    selectedTab = widget.initialSelectedTabIndex ?? _defaultSelectedTabIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: ClientConfig.getCustomColors().neutral300,
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int tabIndex = 0; tabIndex < widget.tabs.length; tabIndex++)
                TabExpandedButton(
                  active: selectedTab == tabIndex,
                  text: widget.tabs[tabIndex].text,
                  textStyle: ClientConfig.getTextStyleScheme().labelSmall,
                  borderRadius: tabIndex == 0
                      ? const BorderRadius.only(topLeft: Radius.circular(8.0), bottomLeft: Radius.circular(8.0))
                      : tabIndex == widget.tabs.length - 1
                          ? const BorderRadius.only(topRight: Radius.circular(8.0), bottomRight: Radius.circular(8.0))
                          : BorderRadius.zero,
                  onPressed: () {
                    setState(() {
                      selectedTab = tabIndex;
                    });
                  },
                )
            ],
          ),
        ),
        widget.tabs[selectedTab].child,
      ],
    );
  }
}

class TabViewItem {
  final String text;
  final Widget child;

  const TabViewItem({
    required this.text,
    required this.child,
  });
}
