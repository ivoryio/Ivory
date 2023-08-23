import 'package:flutter/material.dart';

class ScrollableScreenContainer extends StatelessWidget {
  final ScrollController? scrollController;
  final Widget child;

  const ScrollableScreenContainer({
    super.key,
    this.scrollController,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          controller: scrollController,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(child: child),
          ),
        );
      },
    );
  }
}
