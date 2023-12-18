import 'package:flutter/material.dart';

class ScrollableScreenContainer extends StatelessWidget {
  final ScrollController? scrollController;
  final EdgeInsetsGeometry? padding;
  final Widget child;
  final ScrollPhysics? physics;

  const ScrollableScreenContainer({
    super.key,
    this.scrollController,
    this.padding,
    required this.child,
    this.physics = const ClampingScrollPhysics(),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          controller: scrollController,
          physics: physics,
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
