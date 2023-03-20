import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:solaris_structure_1/router/routing_constants.dart';

import '../../widgets/expanded_button.dart';
import '../../widgets/screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: landingRoute.title,
      hideBottomNavbar: true,
      hideAppBar: true,
      child: Column(
        children: const [
          HeroImage(),
          LandingScreenContent(),
        ],
      ),
    );
  }
}

class LandingScreenContent extends StatelessWidget {
  const LandingScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(children: [
              Row(
                children: const [
                  Flexible(
                    child: Text(
                      "Manage your finances and expenses easily, with Solaris",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: const [
                  Flexible(
                    child: Text(
                      "Manage finances, your wallet, make payments and receipts of finances easily and simply",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff667085),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: PlatformElevatedButton(
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      context.push(loginRoute.path);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: PlatformElevatedButton(
                    color: Color(0xffD9D9D9),
                    child: const Text(
                      "Signup",
                      style: TextStyle(
                        color: Color(0xff747474),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      context.push(signupRoute.path);
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class HeroImage extends StatelessWidget {
  const HeroImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xffD9D9D9),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Icon(
        Icons.image_outlined,
        size: 100,
        color: Color(0xff747474),
      ),
    );
  }
}
