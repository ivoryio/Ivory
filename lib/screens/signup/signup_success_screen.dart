import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:solarisdemo/router/routing_constants.dart';

import '../../themes/default_theme.dart';
import '../../widgets/button.dart';
import '../../widgets/empty_list_message.dart';
import '../../widgets/screen.dart';

class SignupSuccessScreen extends StatelessWidget {
  const SignupSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Screen(
      hideBottomNavbar: true,
      title: "Signup",
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultScreenHorizontalPadding,
            vertical: defaultScreenVerticalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const TextMessageWithCircularImage(
              title: "Sign-up successful",
              message:
                  "Your account has been created. Please log in to continue.",
            ),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: "Log in",
                    onPressed: () async {
                      context.go(loginRoute.path);
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
