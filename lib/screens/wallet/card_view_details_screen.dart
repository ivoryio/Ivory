import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/card_details_cubit/card_details_cubit.dart';
import '../../themes/default_theme.dart';
import '../../widgets/button.dart';
import '../../widgets/card_widget.dart';
import '../../widgets/screen.dart';

class BankCardViewDetailsScreen extends StatelessWidget {
  const BankCardViewDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<BankCardDetailsCubit>().state;

    return Screen(
      scrollPhysics: const NeverScrollableScrollPhysics(),
      title: 'View card details',
      titleTextStyle: const TextStyle(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w600,
      ),
      backButtonIcon: const Icon(Icons.arrow_back, size: 24),
      centerTitle: true,
      hideAppBar: false,
      hideBackButton: false,
      hideBottomNavbar: true,
      child: Padding(
        padding: defaultScreenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                BankCardWidget(
                  cardNumber: state.card!.representation!.maskedPan!,
                  cardHolder:
                      state.card!.representation!.line2 ?? 'data missing',
                  cardExpiry:
                      state.card!.representation!.formattedExpirationDate!,
                  isViewable: false,
                  cardType: 'Physical card',
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Flexible(
                      child: Text(
                        'This information will be displayed for 60 seconds.',
                        style: TextStyle(
                            fontSize: 16,
                            height: 24 / 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 70,
                      height: 70,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(0.0),
                      child: const CircularCountdownTImer(),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                ),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'Back to "Card"',
                    onPressed: () {
                      context
                          .read<BankCardDetailsCubit>()
                          .initializeActivation(state.card!);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CircularCountdownTImer extends StatefulWidget {
  const CircularCountdownTImer({
    super.key,
  });

  @override
  State<CircularCountdownTImer> createState() => _CircularCountdownTImerState();
}

class _CircularCountdownTImerState extends State<CircularCountdownTImer> {
  final int _duration = 60;
  late int _remainingTime;
  late Timer _timer;
  late bool _isRunning;
  late String _showValue;

  @override
  void initState() {
    super.initState();
    _duration;
    _remainingTime = 0;
    _isRunning = false;
    _showValue = '00:00';
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime < _duration - 1) {
          _remainingTime++;
          _showValue = _remainingTime.toString().length == 1
              ? '00:0$_remainingTime'
              : '00:$_remainingTime';
        } else {
          _stopTimer();
        }
      });
    });
  }

  void _stopTimer() {
    _timer.cancel();

    setState(() {
      _isRunning = false;
      _remainingTime = _duration;
    });
  }

  void _handleTap() {
    if (!_isRunning) {
      _startTimer();
    } else {
      _stopTimer();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   // super.didChangeAppLifecycleState(state);
  //   if (state == AppLifecycleState.resumed) {
  //     _startTimer();
  //   } else if (state == AppLifecycleState.paused) {
  //     _timer.cancel();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Center(
              child: Text(
                _isRunning ? _showValue : '01:00',
                style: const TextStyle(
                  fontSize: 14,
                  height: 18 / 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF15141E),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: CircularProgressIndicator(
              strokeWidth: 7,
              value: _remainingTime / _duration,
              backgroundColor: Colors.white,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
