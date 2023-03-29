import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/button.dart';
import '../../widgets/screen.dart';
import '../../router/routing_constants.dart';
import '../../cubits/auth_cubit/auth_cubit.dart';

class LoginPasscodeErrorScreen extends StatelessWidget {
  final String message;
  const LoginPasscodeErrorScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: "Login",
      hideBottomNavbar: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(message),
              PrimaryButton(
                text: "Go to landing page",
                onPressed: () {
                  context.go(landingRoute.path);
                  context.read<AuthCubit>().reset();
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
