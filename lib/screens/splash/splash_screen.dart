import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solaris_structure_1/router/routing_constants.dart';
import 'package:solaris_structure_1/animations/splashscreen_fadeout_animation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      GoRouter.of(context).go(loginPageRoutePath);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SplashScreenFadeoutAnimation(
        image: AssetImage('assets/images/splash.png'),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }
}
