import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:solarisdemo/config.dart';

enum SkeletonColorTheme { light, dark, darkReverse }

class SkeletonTheme {
  final Color baseColor;
  final Color highlightColor;

  const SkeletonTheme({
    required this.baseColor,
    required this.highlightColor,
  });
}

class SkeletonContainer extends StatelessWidget {
  final SkeletonColorTheme colorTheme;
  final Duration? animationDuration;
  final Widget child;
  final bool animationEnabled;

  const SkeletonContainer({
    super.key,
    this.colorTheme = SkeletonColorTheme.dark,
    this.animationDuration,
    this.animationEnabled = true,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _theme.baseColor,
      highlightColor: _theme.highlightColor,
      period: animationDuration ?? const Duration(milliseconds: 1500),
      enabled: animationEnabled,
      child: child,
    );
  }

  SkeletonTheme get _theme {
    final map = {
      SkeletonColorTheme.light: SkeletonTheme(
        baseColor: ClientConfig.getCustomColors().neutral100.withOpacity(0.15),
        highlightColor: ClientConfig.getCustomColors().neutral100.withOpacity(0.02),
      ),
      SkeletonColorTheme.dark: SkeletonTheme(
        baseColor: ClientConfig.getCustomColors().neutral900.withOpacity(0.15),
        highlightColor: ClientConfig.getCustomColors().neutral900.withOpacity(0.05),
      ),
      SkeletonColorTheme.darkReverse: SkeletonTheme(
        baseColor: ClientConfig.getCustomColors().neutral900,
        highlightColor: ClientConfig.getCustomColors().neutral100.withOpacity(0.15),
      ),
    };

    return map[colorTheme]!;
  }
}

class Skeleton extends StatelessWidget {
  final BorderRadiusGeometry borderRadius;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final bool transparent;
  final Color color;

  const Skeleton({
    super.key,
    this.width,
    this.height,
    this.padding,
    this.child,
    this.transparent = false,
    this.borderRadius = const BorderRadius.all(Radius.circular(100)),
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: color,
        backgroundBlendMode: transparent ? BlendMode.clear : null,
      ),
      clipBehavior: Clip.none,
      child: child,
    );
  }
}
