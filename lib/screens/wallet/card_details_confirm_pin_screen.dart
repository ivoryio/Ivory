import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/card_details_cubit/card_details_cubit.dart';
import '../../themes/default_theme.dart';
import '../../utilities/validator.dart';
import '../../widgets/button.dart';
import '../../widgets/pin_field.dart';
import '../../widgets/screen.dart';
import '../../widgets/spaced_column.dart';

class BankCardDetailsConfirmPinScreen extends StatefulWidget {
  const BankCardDetailsConfirmPinScreen({super.key});

  @override
  State<BankCardDetailsConfirmPinScreen> createState() =>
      _BankCardDetailsConfirmPinScreenState();
}

class _BankCardDetailsConfirmPinScreenState
    extends State<BankCardDetailsConfirmPinScreen> {
  late bool twoPinsMatch = true;
  late bool completed = false;
  GlobalKey<FourDigitPinCodeInputState> fourDigitPinKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final state = context.read<BankCardDetailsCubit>().state;

    return Screen(
      scrollPhysics: const NeverScrollableScrollPhysics(),
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
      trailingActions: [
        IconButton(
          icon: Image.asset('assets/icons/porsche_logo.png'),
          iconSize: 40,
          onPressed: () {},
        ),
      ],
      bottomProgressBarPages: const BottomProgressBarPagesIndicator(
        pageNumber: 3,
        numberOfPages: 4,
      ),
      child: Padding(
        padding: defaultScreenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SpacedColumn(
              space: 32,
              children: [
                SpacedColumn(
                  space: 16,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Confirm PIN',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            height: 32 / 24,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Confirm your PIN by typing it again.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 24 / 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FourDigitPinCodeInput(
                      key: fourDigitPinKey,
                      onCompleted: (confirmPin) {
                        if (isPinValid(
                          state.pin!,
                          confirmPin,
                        )) {
                          fourDigitPinKey.currentState?.unfocusAllFields();
                          markCompleted();
                          Future.delayed(
                            const Duration(
                              milliseconds: 500,
                            ),
                            () {
                              context.read<BankCardDetailsCubit>().confirmPin(
                                    state.card!,
                                    state.pin!,
                                  );
                            },
                          );
                        } else {
                          highlightReasonsForInvalidPin(
                            state.pin!,
                            confirmPin,
                          );
                          fourDigitPinKey.currentState?.toggleValidity();
                          fourDigitPinKey.currentState?.clearPin();
                          fourDigitPinKey.currentState?.setFocusOnFirst();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            SpacedColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              space: 10,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check,
                      color: completed
                          ? Colors.green
                          : !twoPinsMatch
                              ? Colors.red
                              : Colors.black,
                      size: 24,
                    ),
                    Text(
                      'Your PIN should match',
                      style: TextStyle(
                        color: completed
                            ? Colors.green
                            : !twoPinsMatch
                                ? Colors.red
                                : Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  bool isPinValid(String firstPin, String secondPin) {
    return !PinValidator.checkIfPinDiffersFromString(secondPin, firstPin);
  }

  void highlightReasonsForInvalidPin(
    String pin,
    String confirmPin,
  ) {
    setState(() {
      twoPinsMatch = !PinValidator.checkIfPinDiffersFromString(
        pin,
        confirmPin,
      );
    });
    Future.delayed(
      const Duration(milliseconds: 2000),
      () {
        if (mounted) {
          restoreValidity();
        }
      },
    );
  }

  void restoreValidity() {
    setState(() {
      twoPinsMatch = true;
    });
  }

  void markCompleted() {
    setState(() {
      completed = true;
    });
  }
}
