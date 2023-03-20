import 'package:flutter/material.dart';

import '../../widgets/screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Screen(
      hideBottomNavbar: true,
      title: "Signup",
      child: Center(
        child: Text('Signup'),
      ),
    );
  }
}
