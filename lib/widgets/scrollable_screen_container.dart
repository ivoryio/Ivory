import 'package:flutter/material.dart';

class ScrollableScreenContainer extends StatelessWidget {
  final ScrollController? scrollController;
  final EdgeInsetsGeometry? padding;
  final Widget child;
  final bool clampingScroll;

  const ScrollableScreenContainer({
    super.key,
    this.scrollController,
    this.padding,
    required this.child,
    this.clampingScroll = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          controller: scrollController,
          physics: clampingScroll ? const ClampingScrollPhysics() : null,
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
