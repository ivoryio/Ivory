import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/themes/default_theme.dart';
import 'package:solarisdemo/widgets/spaced_column.dart';

import '../../cubits/signup/signup_cubit.dart';
import '../../widgets/button.dart';
import '../../widgets/platform_text_input.dart';
import '../../widgets/screen.dart';

class SignupConfirmEmailScreen extends StatelessWidget {
  const SignupConfirmEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var previousState = context.read<SignupCubit>().state;

    String passcode = previousState.passcode!;
    String email = previousState.email!;
    String firstName = previousState.firstName!;
    String lastName = previousState.lastName!;
    String phoneNumber = previousState.phoneNumber!;
    TextEditingController emailConfirmationInputController =
        TextEditingController();

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
            SpacedColumn(
              space: 16,
              children: [
                const Text(
                  'Verify your email address',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Text(
                    'Please check your inbox and enter the confirmation code from the email we`ve sent to:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    )),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                PlatformTextInput(
                  controller: emailConfirmationInputController,
                  validator: (value) => {},
                  onChanged: (value) => {},
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: "Confirm",
                    onPressed: () async {
                      context.read<SignupCubit>().confirmEmail(
                          personId: previousState.personId!,
                          phoneNumber: phoneNumber,
                          emailConfirmationCode:
                              emailConfirmationInputController.text,
                          passcode: passcode,
                          email: email,
                          firstName: firstName,
                          lastName: lastName);
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
