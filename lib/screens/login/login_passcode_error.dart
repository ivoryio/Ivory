import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../router/routing_constants.dart';
import '../../widgets/screen.dart';

class LoginPasscodeErrorScreen extends StatelessWidget {
  const LoginPasscodeErrorScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: "Login",
      hideBottomNavbar: true,
      child: Column(
        children: [
          Text("Error:  for username "),
          PlatformTextButton(
            child: const Text("Go to landing page"),
            onPressed: () {
              context.go(landingRoute.path);
              context.read<AuthCubit>().reset();
            },
          )
        ],
      ),
    );
  }
}
