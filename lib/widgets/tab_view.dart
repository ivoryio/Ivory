import 'package:flutter/material.dart';

import 'button.dart';

class TabViewItem {
  final String text;
  final Widget child;

  const TabViewItem({
    required this.text,
    required this.child,
  });
}

class TabView extends StatefulWidget {
  final List<TabViewItem> tabs;

  const TabView({
    super.key,
    required this.tabs,
  });

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
              color: const Color(0xfff5f5f5),
              borderRadius: const BorderRadius.all(Radius.circular(9.0)),
              border: Border.all(width: 1, color: const Color(0xffB9B9B9))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int tabIndex = 0; tabIndex < widget.tabs.length; tabIndex++)
                TabExpandedButton(
                  active: selectedTab == tabIndex,
                  text: widget.tabs[tabIndex].text,
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
