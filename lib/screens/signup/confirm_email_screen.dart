import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/platform_text_input.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/spaced_column.dart';

import '../../config.dart';
import '../../cubits/signup/signup_cubit.dart';

class SignupConfirmEmailScreen extends StatelessWidget {
  static const routeName = "/signupConfirmEmailScreen";

  const SignupConfirmEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var previousState = context.read<SignupCubit>().state;
    print(previousState);
    String passcode = previousState.passcode!;
    String email = previousState.email!;
    String firstName = previousState.firstName!;
    String lastName = previousState.lastName!;
    String phoneNumber = previousState.phoneNumber!;
    TextEditingController emailConfirmationInputController =
        TextEditingController();

    return ScreenScaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ClientConfig.getCustomClientUiSettings()
              .defaultScreenHorizontalPadding,
        ),
        child: Column(
          children: [
            const AppToolbar(title: "Signup"),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
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
                      hintText: "ex. 123456",
                      controller: emailConfirmationInputController,
                      keyboardType: TextInputType.phone,
                      onChanged: (value) => {
                        if (value.length == 6)
                          {
                            context.read<SignupCubit>().confirmEmail(
                                  personId: previousState.personId!,
                                  phoneNumber: phoneNumber,
                                  emailConfirmationCode:
                                      emailConfirmationInputController.text,
                                  passcode: passcode,
                                  email: email,
                                  firstName: firstName,
                                  lastName: lastName,
                                )
                          }
                      },
                      validator: (value) {},
                    ),
                    if (previousState.errorMessage != null)
                      Text(
                        previousState.errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );

    /*

    return Screen(
      hideBottomNavbar: true,
      title: "Signup",
      child: Padding(
        padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
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
                  hintText: "ex. 123456",
                  controller: emailConfirmationInputController,
                  keyboardType: TextInputType.phone,
                  onChanged: (value) => {
                    if (value.length == 6)
                      {
                        context.read<SignupCubit>().confirmEmail(
                              personId: previousState.personId!,
                              phoneNumber: phoneNumber,
                              emailConfirmationCode:
                                  emailConfirmationInputController.text,
                              passcode: passcode,
                              email: email,
                              firstName: firstName,
                              lastName: lastName,
                            )
                      }
                  },
                  validator: (value) {},
                ),
                if (previousState.errorMessage != null)
                  Text(
                    previousState.errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );

     */
  }
}
