import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../widgets/screen.dart';
import '../../widgets/spaced_column.dart';
import '../../widgets/tan_input.dart';
import '../../cubits/login_cubit/login_cubit.dart';

class LoginTanScreen extends StatelessWidget {
  const LoginTanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: "Login",
      hideBottomNavbar: true,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SpacedColumn(
                    space: 40,
                    children: [
                      const Text(
                        "Nice to see you again!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TanInput(
                        length: 4,
                        onCompleted: (String tan) {
                          final LoginCubit loginCubit =
                              context.read<LoginCubit>();

                          loginCubit.login(tan);
                        },
                      ),
                      const Text(
                        'Please enter your 4-digit PIN to login. (PIN: 1234)',
                      ),
                    ],
                  ),
                ],
              ),
              const LoginPasscodeFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPasscodeFooter extends StatelessWidget {
  const LoginPasscodeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformTextButton(
        child: const Text("Forgot your passcode?"),
        onPressed: () {
          log("Forgot your passcode?");
        });
  }
}
