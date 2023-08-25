import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solarisdemo/screens/landing/landing_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../config.dart';
import '../../cubits/signup/signup_cubit.dart';
import '../../widgets/button.dart';

class CountdownScreen extends StatefulWidget {
  static const routeName = "/countdownScreen";

  const CountdownScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CountdownScreenState createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen>
    with WidgetsBindingObserver {
  Timer? _timer;
  int _start = 3 * 60; // 3 minutes in seconds

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    restoreTimer();
  }

  Future<void> restoreTimer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var endTime = prefs.getInt('signup_countdown_end_time');
    if (endTime != null) {
      _start = endTime - DateTime.now().millisecondsSinceEpoch ~/ 1000;
      if (_start > 0) {
        startTimer();
      } else {
        setState(() {
          _start = 0;
        });
        prefs.remove('signup_countdown_end_time');
      }
    } else {
      startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
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
            saveEndTime(null);
          });
        } else {
          setState(() {
            _start--;
            saveEndTime(DateTime.now().millisecondsSinceEpoch ~/ 1000 + _start);
          });
        }
      },
    );
  }

  Future<void> saveEndTime(int? endTime) async {
    if (endTime == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('signup_countdown_end_time');
      return;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('signup_countdown_end_time', endTime);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      restoreTimer();
    } else if (state == AppLifecycleState.paused) {
      _timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    var state = context.read<SignupCubit>().state;
    if (state.user == null) {
      log('User is null');
    }
    int minutes = _start ~/ 60;
    int seconds = _start % 60;

    return ScreenScaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: ClientConfig.getCustomClientUiSettings()
                .defaultScreenHorizontalPadding),
        child: Column(
          children: [
            const AppToolbar(title: "Sign Up"),
            Expanded(
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
                    if (_start != 0)
                      const SizedBox(
                        height: 64,
                      ),
                    if (_start != 0)
                      const Text(
                        'Almost there!',
                      ),
                    if (_start != 0)
                      const Text(
                          'Your personalized experience is being prepared.'),
                    if (_start == 0)
                      SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(
                          text: "Let's get started!",
                          onPressed: () {
                            context.read<SignupCubit>().createAccount(
                                  state.user!,
                                );

                            Navigator.popUntil(
                              context,
                              ModalRoute.withName(LandingScreen.routeName),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
