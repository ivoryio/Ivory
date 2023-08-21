import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';
import 'package:solarisdemo/infrastructure/bank_card/activation/bank_card_activation_presenter.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/bank_card/activation/bank_card_activation_action.dart';

import '../../config.dart';
import '../../redux/app_state.dart';
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

    return StoreConnector<AppState, BankCardActivationViewModel>(
      converter: (store) =>
          BankCardActivationPresenter.presentBankCardActivation(
        bankCardActivationState: store.state.bankCardActivationState,
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
                      text: 'out of 4',
                      style: TextStyle(color: Color(0xFF56555E)),
                    ),
                  ],
                )),
                padding: EdgeInsets.symmetric(
                  horizontal: ClientConfig.getCustomClientUiSettings()
                      .defaultScreenHorizontalPadding,
                ),
                backButtonEnabled: true, //needs to be false
              ),
              const LinearProgressIndicator(
                value: 2 / 4,
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
                                    BankCardActivationChoosePinCommandAction(
                                      pin: pin,
                                    ),
                                  );
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
