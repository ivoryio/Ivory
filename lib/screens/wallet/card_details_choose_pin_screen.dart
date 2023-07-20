import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/widgets/spaced_column.dart';

import '../../cubits/card_details_cubit/card_details_cubit.dart';
import '../../themes/default_theme.dart';
import '../../utilities/validator.dart';
import '../../widgets/pin_field.dart';
import '../../widgets/screen.dart';

class BankCardDetailsChoosePinScreen extends StatefulWidget {
  BankCardDetailsChoosePinScreen({super.key});

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
        pageNumber: 2,
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
                  children: [
                    const Text(
                      'Choose PIN',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        height: 1.33,
                      ),
                    ),
                    const Text(
                      'Remember your PIN as you will use it for all future card purchases.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    FourDigitPinCodeInput(
                      key: fourDigitPinKey,
                      onCompleted: (pin) {
                        if (isPinValid(
                          '5885',
                          '1991',
                          pin,
                        )) {
                          fourDigitPinKey.currentState?.unfocusAllFields();
                          markCompleted();
                          Future.delayed(
                            const Duration(seconds: 1),
                            () {
                              context
                                  .read<BankCardDetailsCubit>()
                                  .choosePin(state.card!, pin);
                            },
                          );
                        } else {
                          highlightReasonsForInvalidPin('1234', '1234', pin);
                          fourDigitPinKey.currentState?.toggleValidity();
                          fourDigitPinKey.currentState?.clearPin();
                          fourDigitPinKey.currentState?.setFocusOnFirst();
                        }
                      },
                    ),
                  ],
                )
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
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: PrimaryButton(
                  //     text: "Insert 4 digit for PIN",
                  //     onPressed: () {
                  //       context
                  //           .read<BankCardDetailsCubit>()
                  //           .choosePin(state.card!, "0000");
                  //     },
                  //   ),
                  // ),
                ],
              )
          ],
        ),
      ),
    );
  }

  bool isPinValid(String postalCode, String birthDate, String pin) {
    return PinValidator.checkIfPinDiffersFromString('1234', pin) &&
        PinValidator.checkIfPinDiffersFromBirthDate('1234', pin) &&
        PinValidator.checkIfPinIsNotSequence(pin) &&
        PinValidator.checkPinHasNoDigitsRepeating(pin);
  }

  void highlightReasonsForInvalidPin(
    String birthDate,
    String postalCode,
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
      const Duration(seconds: 3),
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
