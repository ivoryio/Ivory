import 'package:flutter/material.dart';
import 'package:solarisdemo/screens/login/login_screen.dart';
import 'package:solarisdemo/screens/signup/signup_screen.dart';
import 'package:solarisdemo/screens/transactions/transaction_approval_pending_screen.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

import '../../widgets/button.dart';
import '../../widgets/spaced_column.dart';

class LandingScreen extends StatelessWidget {
  static const routeName = "/landingScreen";

  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScreenScaffold(
      statusBarColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: ScrollableScreenContainer(
        child: Column(
          children: [
            HeroImage(),
            LandingScreenContent(),
          ],
        ),
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
            const Column(children: [
              Row(
                children: [
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
              SizedBox(height: 10),
              Row(
                children: [
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
            SpacedColumn(
              space: 10,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: "Login",
                    onPressed: () {
                      Navigator.pushNamed(context, LoginScreen.routeName);
                    },
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: SecondaryButton(
                    text: "Signup",
                    onPressed: () {
                      Navigator.pushNamed(context, SignupScreen.routeName);
                    },
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: SecondaryButton(
                    text: "Transaction approval",
                    onPressed: () {
                      Navigator.pushNamed(context, TransactionApprovalPendingScreen.routeName);
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
      child: const Icon(
        Icons.image_outlined,
        size: 100,
        color: Color(0xff747474),
      ),
    );
  }
}
