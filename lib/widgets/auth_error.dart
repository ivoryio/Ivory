import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/screens/landing/landing_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../widgets/button.dart';
import '../../widgets/screen.dart';

class AuthErrorScreen extends StatelessWidget {
  final String title;
  final String message;

  const AuthErrorScreen(
      {super.key, required this.message, required this.title});

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
                      context.read<AuthCubit>().reset();
                      Navigator.popUntil(
                        context,
                        ModalRoute.withName(
                          LandingScreen.routeName,
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
    return Screen(
      title: title,
      hideBottomNavbar: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [],
      ),
    );
  }
}
