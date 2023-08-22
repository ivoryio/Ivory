import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/screens/wallet/card_details_info.dart';

import '../../config.dart';
import '../../infrastructure/bank_card/bank_card_presenter.dart';
import '../../redux/app_state.dart';
import '../../redux/bank_card/bank_card_action.dart';
import '../../utilities/validator.dart';
import '../../widgets/app_toolbar.dart';
import '../../widgets/pin_field.dart';
import '../../widgets/screen_scaffold.dart';
import 'card_details_confirm_pin_screen.dart';

class BankCardDetailsChoosePinScreen extends StatefulWidget {
  static const routeName = '/bankCardDetailsChoosePinScreen';

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
    AuthenticatedUser user = context.read<AuthCubit>().state.user!;

    return StoreConnector<AppState, BankCardViewModel>(
      converter: (store) => BankCardPresenter.presentBankCard(
        bankCardState: store.state.bankCardState,
        user: user,
      ),
      builder: (context, viewModel) {
        return ScreenScaffold(
          body: Column(
            children: [
              AppToolbar(
                richTextTitle: RichText(
                    text: const TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Step 2 ',
                      style: TextStyle(color: Color(0xFF15141E)),
                    ),
                    TextSpan(
                      text: 'out of 3',
                      style: TextStyle(color: Color(0xFF56555E)),
                    ),
                  ],
                )),
                padding: EdgeInsets.symmetric(
                  horizontal: ClientConfig.getCustomClientUiSettings()
                      .defaultScreenHorizontalPadding,
                ),
                backButtonEnabled: true,
                onBackButtonPressed: () {
                  Navigator.pop(context);
                },
              ),
              const LinearProgressIndicator(
                value: 2 / 3,
                color: Color(0xFF2575FC),
                backgroundColor: Color(0xFFE9EAEB),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ClientConfig.getCustomClientUiSettings()
                      .defaultScreenHorizontalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 24,
                    ),
                    const Text(
                      'Choose PIN',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        height: 1.33,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Remember your PIN as you will use it for all future card purchases.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FourDigitPinCodeInput(
                          key: fourDigitPinKey,
                          onCompleted: (pin) {
                            if (isPinValid(
                              viewModel.user!.person.address!.postalCode!,
                              viewModel.user!.person.birthDate!,
                              pin,
                            )) {
                              fourDigitPinKey.currentState?.unfocusAllFields();
                              fourDigitPinKey.currentState?.setAllFieldsDone();
                              markCompleted();
                              Future.delayed(
                                const Duration(milliseconds: 500),
                                () {
                                  StoreProvider.of<AppState>(context).dispatch(
                                    BankCardChoosePinCommandAction(
                                      bankCard: viewModel.bankCard!,
                                      user: user,
                                      pin: pin,
                                    ),
                                  );
                                  restoreValidity();
                                  Navigator.pushNamed(
                                    context,
                                    BankCardDetailsConfirmPinScreen.routeName,
                                  );
                                },
                              );
                            } else {
                              highlightReasonsForInvalidPin(
                                viewModel.user!.person.address!.postalCode!,
                                viewModel.user!.person.birthDate!,
                                pin,
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
              ),
              if (!completed) const Spacer(),
              if (!completed)
                Padding(
                  padding: EdgeInsets.only(
                    right: ClientConfig.getCustomClientUiSettings()
                        .defaultScreenHorizontalPadding,
                    left: ClientConfig.getCustomClientUiSettings()
                        .defaultScreenHorizontalPadding,
                    bottom: ClientConfig.getCustomClientUiSettings()
                        .defaultScreenHorizontalPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      const SizedBox(height: 10),
                      PinValidityRule(
                        isValid: pinDiffersBirthDate,
                        text: 'Your date of birth',
                        icon: Icons.close,
                      ),
                      PinValidityRule(
                        isValid: pinDiffersPostalCode,
                        text: 'Your postal code',
                        icon: Icons.close,
                      ),
                      PinValidityRule(
                        isValid: pinIsNotASequence,
                        text: 'Number sequences, e.g. 1234',
                        icon: Icons.close,
                      ),
                      PinValidityRule(
                        isValid: pinNotContainsRepeatingDigits,
                        text: 'More than two digits repeating',
                        icon: Icons.close,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
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

class PinValidityRule extends StatelessWidget {
  final bool isValid;
  final String text;
  final IconData icon;

  const PinValidityRule({
    super.key,
    required this.isValid,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 24,
          color: isValid ? Colors.black : Colors.red,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.5,
            color: isValid ? Colors.black : Colors.red,
          ),
        ),
      ],
    );
  }
}
