import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/screens/login/login_screen.dart';
import '../../widgets/button.dart';
import '../../widgets/platform_text_input.dart';

import '../../cubits/signup/signup_cubit.dart';
import '../../widgets/screen.dart';

class SignupSetupPasscodeScreen extends StatelessWidget {
  const SignupSetupPasscodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SignupState previousState = context.read<SignupCubit>().state;
    String email = previousState.email!;
    String phoneNumber = previousState.phoneNumber!;
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
              context.read<SignupCubit>().setConsent(
                    phoneNumber: phoneNumber,
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
