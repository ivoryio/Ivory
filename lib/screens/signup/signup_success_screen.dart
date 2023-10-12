import 'package:flutter/widgets.dart';
import 'package:solarisdemo/screens/welcome/welcome_screen.dart';
import 'package:solarisdemo/screens/login/login_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../config.dart';
import '../../widgets/button.dart';
import '../../widgets/empty_list_message.dart';

class SignupSuccessScreen extends StatelessWidget {
  static const routeName = "/signupSuccessScreen";

  const SignupSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Padding(
        padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
        child: Column(
          children: [
            const AppToolbar(title: "Signup", backButtonEnabled: false),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TextMessageWithCircularImage(
                    title: "Sign-up successful",
                    message: "Your account has been created. Please log in to continue.",
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(
                          text: "Log in",
                          onPressed: () async {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              LoginScreen.routeName,
                              ModalRoute.withName(WelcomeScreen.routeName),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
