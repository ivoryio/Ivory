import 'package:flutter/material.dart';

class SplashScreenFadeoutAnimation extends StatefulWidget {
  final AssetImage image;
  final Duration duration;

  const SplashScreenFadeoutAnimation(
      {super.key,
      required this.image,
      this.duration = const Duration(milliseconds: 500)});

  @override
  State<SplashScreenFadeoutAnimation> createState() =>
      _SplashScreenFadeoutAnimationState();
}

class _SplashScreenFadeoutAnimationState
    extends State<SplashScreenFadeoutAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: widget.duration);
    _fadeAnimation =
        Tween<double>(begin: 2.0, end: 0.0).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: widget.image,
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
    );
  }
}
