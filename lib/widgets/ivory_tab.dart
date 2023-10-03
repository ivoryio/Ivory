import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:solarisdemo/widgets/button.dart';

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

          buttons.add(
            Expanded(
              child: Button(
                text: title,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: isActive ? Colors.white : const Color(0xFFDFE2E6),
                textColor: const Color(0xFF15141E),
                border: isActive ? null : Border.all(width: 1, color: const Color(0xFFDFE2E6)),
                borderRadius: 8,
                onPressed: () {
                  controller.changeIndex(tabIndex);
                  onPressed?.call();
                },
              ),
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
              color: const Color(0xFFDFE2E6),
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              border: Border.all(width: 1, color: const Color(0xFFDFE2E6))),
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
