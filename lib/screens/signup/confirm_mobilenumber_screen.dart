
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/cubits/signup/signup_cubit.dart';

import '../../widgets/screen.dart';
import '../../widgets/spaced_column.dart';
import '../../widgets/tan_input.dart';

class SignupConfirmMobilenumberScreen extends StatelessWidget {
  const SignupConfirmMobilenumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var previousState = context.read<SignupCubit>().state;
    String phoneNumber = previousState.phoneNumber!;
    return Screen(
      title: "Signup",
      hideBottomNavbar: true,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SpacedColumn(
                space: 16,
                children: [
                  const Text(
                    'Verify your mobile number',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TanInput(
                    length: 6,
                    onCompleted: (String tan) {
                      context.read<SignupCubit>().confirmPhoneNumber(
                          phoneNumber: previousState.phoneNumber!,
                          user: previousState.user!,
                          mobileNumberConfirmationCode: tan);
                    },
                  ),
                  const Text(
                    'Please enter your 6-digit confirmation code (123456) recieved in SMS we`ve sent to:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    phoneNumber,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
