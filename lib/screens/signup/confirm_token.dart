import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/signup/signup_cubit.dart';
import '../../widgets/button.dart';
import '../../widgets/platform_text_input.dart';
import '../../widgets/screen.dart';

class SignupConfirmTokenScreen extends StatelessWidget {
  const SignupConfirmTokenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var previousState = context.read<SignupCubit>().state;

    String passcode = previousState.passcode!;
    String email = previousState.email!;
    String firstName = previousState.firstName!;
    String lastName = previousState.lastName!;
    TextEditingController tokenInputController = TextEditingController();

    return Screen(
      hideBottomNavbar: true,
      title: "Signup",
      child: Column(
        children: [
          PlatformTextInput(
            controller: tokenInputController,
            textLabel: "Token",
            validator: (value) => {},
            onChanged: (value) => {},
          ),
          PrimaryButton(
            text: "Confirm token",
            onPressed: () {
              context.read<SignupCubit>().confirmToken(
                  token: tokenInputController.text,
                  passcode: passcode,
                  email: email,
                  firstName: firstName,
                  lastName: lastName);
            },
          ),
        ],
      ),
    );
  }
}
