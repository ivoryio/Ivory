import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:solarisdemo/router/routing_constants.dart';

import '../../cubits/signup/signup_cubit.dart';
import '../../themes/default_theme.dart';
import '../../widgets/button.dart';
import '../../widgets/screen.dart';

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CountdownScreenState createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  Timer? _timer;
  int _start = 3 * 60; // 3 minutes in seconds

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = context.read<SignupCubit>().state;
    if (state.user == null) {
      log('User is null');
    }
    int minutes = _start ~/ 60;
    int seconds = _start % 60;

    return Screen(
      title: "Sign Up",
      hideAppBar: true,
      hideBottomNavbar: true,
      hideBackButton: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: defaultScreenHorizontalPadding,
          vertical: defaultScreenVerticalPadding,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (_start != 0)
                Text(
                  '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 50,
                  ),
                ),
              if (_start == 0)
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: "Let's get started!",
                    onPressed: () {
                      context.read<SignupCubit>().createAccount(
                            state.user!,
                          );
                      context.go(landingRoute.path);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
