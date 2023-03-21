import 'package:flutter/material.dart';

import '../../widgets/screen.dart';

class LoginPasscodeScreen extends StatelessWidget {
  const LoginPasscodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Screen(
      title: "Login",
      hideBottomNavbar: true,
      child: Center(
        child: Text("LoginPasscodeScreen"),
      ),
    );
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