import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:solarisdemo/widgets/button.dart';

import '../config.dart';

class IvoryTab extends Equatable {
  final String title;
  final void Function()? onPressed;

  const IvoryTab({
    required this.title,
    this.onPressed,
  });

  @override
  List<Object?> get props => [title];
}

class IvoryTabBar extends StatelessWidget {
  final IvoryTabController controller;
  final List<IvoryTab> tabs;

  IvoryTabBar({super.key, required this.tabs, required this.controller}) : assert(tabs.length == controller.tabsCount);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        final List<Widget> buttons = [];

        for (int tabIndex = 0; tabIndex < tabs.length; tabIndex++) {
          final isActive = tabIndex == controller.currentIndex;
          final title = tabs[tabIndex].title;
          final onPressed = tabs[tabIndex].onPressed;
          final isFirst = tabIndex == 0;
          final isLast = tabIndex == tabs.length - 1;

          buttons.add(
            Expanded(
              child: Button(
                text: title,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: isActive ? Colors.white : ClientConfig.getCustomColors().neutral300,
                textColor: ClientConfig.getCustomColors().neutral900,
                borderRadius: BorderRadius.only(
                  topLeft: isFirst ? const Radius.circular(8) : Radius.zero,
                  bottomLeft: isFirst ? const Radius.circular(8) : Radius.zero,
                  topRight: isLast ? const Radius.circular(8) : Radius.zero,
                  bottomRight: isLast ? const Radius.circular(8) : Radius.zero,
                ),
                onPressed: () {
                  if (isActive) return;

                  controller.changeIndex(tabIndex);
                  onPressed?.call();
                },
              ),
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: ClientConfig.getCustomColors().neutral300,
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Row(children: buttons),
        );
      },
    );
  }
}

class IvoryTabView extends StatelessWidget {
  final IvoryTabController controller;
  final List<Widget> children;

  IvoryTabView({
    super.key,
    required this.controller,
    required this.children,
  }) : assert(children.length == controller.tabsCount);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return children[controller.currentIndex];
      },
    );
  }
}

class IvoryTabController extends ChangeNotifier {
  final int tabsCount;
  final int initialIndex;

  late int _index;

  IvoryTabController({this.tabsCount = 0, this.initialIndex = 0}) {
    _index = initialIndex;
  }

  int get currentIndex => _index;

  void changeIndex(int value) {
    _index = value;
    notifyListeners();
  }
}
