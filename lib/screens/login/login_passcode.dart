import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:solaris_structure_1/widgets/button.dart';
import 'package:solaris_structure_1/widgets/platform_text_input.dart';

import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../widgets/overlay_loading.dart';
import '../../widgets/screen.dart';

class LoginPasscodeScreen extends StatelessWidget {
  final String username;
  const LoginPasscodeScreen({super.key, required this.username});

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
            children: const [
              LoginPasscodeBody(),
              LoginPasscodeFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPasscodeBody extends StatelessWidget {
  const LoginPasscodeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Nice to see you again!",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 40),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              InputCodeBox(),
              InputCodeBox(),
              InputCodeBox(),
              InputCodeBox(),
            ],
          ),
        )
      ],
    );
  }
}

class InputCodeBox extends StatelessWidget {
  const InputCodeBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          width: 1,
          color: const Color(0xffC4C4C4),
        ),
      ),
      child: const PlatformTextFormField(
        textAlign: TextAlign.center,
        maxLength: 1,
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
          OverlayLoadingProgress.start(context, barrierDismissible: false);
          context.read<AuthCubit>().login("test");
        });
  }
}


// final userPool = CognitoUserPool(
//   'eu-west-1_Z7d8UgNEM',
//   '2iccudrlh0j2m4pd3tii9d8p13',
// );
// final userAttributes = [
//   AttributeArg(name: 'given_name', value: 'Ilie'),
//   AttributeArg(name: 'family_name', value: 'Lupu'),
// ];

// try {
//   CognitoUserPoolData data = await userPool.signUp(
//     'ilie.lupu@thinslices.com',
//     '123456',
//     userAttributes: userAttributes,
//   );

//   inspect(data);
// } catch (e) {
//   print(e);
// }

// if (_formKey.currentState!.validate()) {
//   _formKey.currentState!.save();
//   String phoneNumber = phoneController.text;

//   log("Phone number: $phoneNumber");

//   context.read<AuthCubit>().login(phoneNumber);
// }
