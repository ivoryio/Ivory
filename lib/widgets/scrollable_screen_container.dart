import 'package:flutter/material.dart';

class ScrollableScreenContainer extends StatelessWidget {
  final ScrollController? scrollController;
  final EdgeInsetsGeometry? padding;
  final Widget child;

  const ScrollableScreenContainer({
    super.key,
    this.scrollController,
    this.padding,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: padding,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(child: child),
          ),
        );
      },
    );
  }
}
