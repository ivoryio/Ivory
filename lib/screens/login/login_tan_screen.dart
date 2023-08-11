import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/cubits/login_cubit/login_cubit.dart';
import 'package:solarisdemo/navigator.dart';
import 'package:solarisdemo/screens/home/home_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/tan_input.dart';

class LoginTanScreen extends StatelessWidget {
  static const routeName = "/loginTanScreen";

  const LoginTanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const AppToolbar(title: "Login"),
            const Text(
              "Nice to see you again!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            TanInput(
              length: 4,
              onCompleted: (String tan) {
                final LoginCubit loginCubit = context.read<LoginCubit>();

                loginCubit.login(tan, onSuccess: () {
                  Navigator.pushNamedAndRemoveUntil(
                    navigatorKey.currentContext as BuildContext,
                    HomeScreen.routeName,
                    (route) => false,
                  );
                });
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Please enter your 4-digit PIN to login. (PIN: 1234)',
            ),
            const Spacer(),
            const LoginPasscodeFooter(),
          ],
        ),
      ),
    );
  }
}

class LoginPasscodeFooter extends StatelessWidget {
  const LoginPasscodeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        child: const Text("Forgot your passcode?"),
        onPressed: () {
          log("Forgot your passcode?");
        });
  }
}
