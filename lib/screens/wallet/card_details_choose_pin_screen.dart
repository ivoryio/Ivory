import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';
import 'package:solarisdemo/widgets/spaced_column.dart';

import '../../config.dart';
import '../../cubits/card_details_cubit/card_details_cubit.dart';
import '../../utilities/validator.dart';
import '../../widgets/pin_field.dart';
import '../../widgets/screen.dart';

class BankCardDetailsChoosePinScreen extends StatefulWidget {
  const BankCardDetailsChoosePinScreen({super.key});

  @override
  State<BankCardDetailsChoosePinScreen> createState() =>
      _BankCardDetailsChoosePinScreenState();
}

class _BankCardDetailsChoosePinScreenState
    extends State<BankCardDetailsChoosePinScreen> {
  late bool pinDiffersBirthDate = true;
  late bool pinDiffersPostalCode = true;
  late bool pinIsNotASequence = true;
  late bool pinNotContainsRepeatingDigits = true;
  late bool completed = false;
  GlobalKey<FourDigitPinCodeInputState> fourDigitPinKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final state = context.read<BankCardDetailsCubit>().state;
    DateTime birthDate =
        context.read<AuthCubit>().state.user!.person.birthDate!;
    String postalCode =
        context.read<AuthCubit>().state.user!.person.address!.postalCode!;

    log('postalCode: $postalCode');
    log('birthDate: $birthDate');

    return Screen(
      scrollPhysics: const NeverScrollableScrollPhysics(),
      titleTextStyle: const TextStyle(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w600,
      ),
      backButtonIcon: const Icon(Icons.arrow_back, size: 24),
      customBackButtonCallback: () {
        context.read<BankCardDetailsCubit>().initializeActivation(state.card!);
      },
      centerTitle: true,
      hideAppBar: false,
      hideBackButton: false,
      hideBottomNavbar: true,
      trailingActions: [
        IconButton(
          icon: Image.asset(ClientConfig.getAssetIconPath('small_logo.png')),
          iconSize: 40,
          onPressed: () {},
        ),
      ],
      bottomProgressBarPages: const BottomProgressBarPagesIndicator(
        pageNumber: 2,
        numberOfPages: 4,
      ),
      child: Padding(
        padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
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
                    Text(
                      'Choose PIN',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        height: 1.33,
                      ),
                    ),
                    Text(
                      'Remember your PIN as you will use it for all future card purchases.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
                FourDigitPinCodeInput(
                  key: fourDigitPinKey,
                  onCompleted: (pin) {
                    if (isPinValid(
                      postalCode,
                      birthDate,
                      pin,
                    )) {
                      fourDigitPinKey.currentState?.unfocusAllFields();
                      markCompleted();
                      Future.delayed(
                        const Duration(milliseconds: 500),
                        () {
                          context
                              .read<BankCardDetailsCubit>()
                              .choosePin(state.card!, pin);
                        },
                      );
                    } else {
                      highlightReasonsForInvalidPin(postalCode, birthDate, pin);
                      fourDigitPinKey.currentState?.toggleValidity();
                      fourDigitPinKey.currentState?.clearPin();
                      fourDigitPinKey.currentState?.setFocusOnFirst();
                    }
                  },
                ),
              ],
            ),
            if (!completed)
              SpacedColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                space: 10,
                children: [
                  const Text(
                    'Your PIN should not contain:',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                  SpacedColumn(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    space: 0,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.close,
                            size: 24,
                          ),
                          Text(
                            'Your date of birth',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                              color: pinDiffersBirthDate
                                  ? Colors.black
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.close,
                            size: 24,
                          ),
                          Text(
                            'Your postal code',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                              color: pinDiffersPostalCode
                                  ? Colors.black
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.close,
                            size: 24,
                          ),
                          Text(
                            'Number sequences, e.g. 1234',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                              color:
                                  pinIsNotASequence ? Colors.black : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.close,
                            size: 24,
                          ),
                          Text(
                            'More than two digits repeating',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                              color: pinNotContainsRepeatingDigits
                                  ? Colors.black
                                  : Colors.red,
                            ),
                          ),
                        ],
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

  bool isPinValid(String postalCode, DateTime birthDate, String pin) {
    return PinValidator.checkIfPinDiffersFromString(postalCode, pin) &&
        PinValidator.checkIfPinDiffersFromBirthDate(birthDate, pin) &&
        PinValidator.checkIfPinIsNotSequence(pin) &&
        PinValidator.checkPinHasNoDigitsRepeating(pin);
  }

  void highlightReasonsForInvalidPin(
    String postalCode,
    DateTime birthDate,
    String pin,
  ) {
    setState(() {
      pinDiffersBirthDate = PinValidator.checkIfPinDiffersFromBirthDate(
        birthDate,
        pin,
      );
      pinDiffersPostalCode = PinValidator.checkIfPinDiffersFromString(
        postalCode,
        pin,
      );
      pinIsNotASequence = PinValidator.checkIfPinIsNotSequence(
        pin,
      );
      pinNotContainsRepeatingDigits = PinValidator.checkPinHasNoDigitsRepeating(
        pin,
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
      pinDiffersBirthDate = true;
      pinDiffersPostalCode = true;
      pinIsNotASequence = true;
      pinNotContainsRepeatingDigits = true;
    });
  }

  void markCompleted() {
    setState(() {
      completed = true;
    });
  }
}
