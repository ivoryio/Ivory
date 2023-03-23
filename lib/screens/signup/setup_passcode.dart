import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:solaris_structure_1/widgets/button.dart';
import 'package:solaris_structure_1/widgets/platform_text_input.dart';

import '../../cubits/signup/signup_cubit.dart';
import '../../widgets/screen.dart';

class SignupSetupPasscodeScreen extends StatelessWidget {
  const SignupSetupPasscodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var previousState = context.read<SignupCubit>().state;
    String email = previousState.email!;
    String firstName = previousState.firstName!;
    String lastName = previousState.lastName!;
    TextEditingController passcodeController = TextEditingController();

    return Screen(
      hideBottomNavbar: true,
      title: "Signup",
      child: Column(
        children: [
          PlatformTextInput(
            controller: passcodeController,
            textLabel: "Passcode",
            validator: (value) => {},
            onChanged: (value) => {},
          ),
          PrimaryButton(
            text: "Continue to insert token",
            onPressed: () {
              context.read<SignupCubit>().setPasscode(
                    passcode: passcodeController.text,
                    email: email,
                    firstName: firstName,
                    lastName: lastName,
                  );
            },
          ),
        ],
      ),
    );
  }
}
