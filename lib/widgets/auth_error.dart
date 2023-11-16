import 'package:flutter/material.dart';
import 'package:solarisdemo/screens/welcome/welcome_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../widgets/button.dart';

class AuthErrorScreen extends StatelessWidget {
  final String title;
  final String message;

  const AuthErrorScreen({super.key, required this.message, required this.title});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            AppToolbar(title: title),
            Center(
              child: Column(
                children: [
                  Text(message),
                  PrimaryButton(
                    text: "Go to landing page",
                    onPressed: () {
                      Navigator.popUntil(
                        context,
                        ModalRoute.withName(
                          WelcomeScreen.routeName,
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
