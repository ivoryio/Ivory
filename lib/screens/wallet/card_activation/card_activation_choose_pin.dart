import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/bank_card/bank_card_presenter.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/bank_card/bank_card_action.dart';
import 'package:solarisdemo/screens/wallet/card_activation/card_activation_confirm_pin_screen.dart';
import 'package:solarisdemo/utilities/validator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/pin_field.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

class BankCardDetailsChoosePinScreen extends StatefulWidget {
  static const routeName = '/bankCardDetailsChoosePinScreen';

  const BankCardDetailsChoosePinScreen({super.key});

  @override
  State<BankCardDetailsChoosePinScreen> createState() => _BankCardDetailsChoosePinScreenState();
}

class _BankCardDetailsChoosePinScreenState extends State<BankCardDetailsChoosePinScreen> {
  late bool pinDiffersBirthDate = true;
  late bool pinDiffersPostalCode = true;
  late bool pinIsNotASequence = true;
  late bool pinNotContainsRepeatingDigits = true;
  late bool completed = false;
  GlobalKey<FourDigitPinCodeInputState> fourDigitPinKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final user =
        (StoreProvider.of<AppState>(context).state.authState as AuthenticatedAndConfirmedState).authenticatedUser;

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
                    text: TextSpan(
                  style: ClientConfig.getTextStyleScheme().heading4,
                  children: const <TextSpan>[
                    TextSpan(
                      text: 'Step 2 ',
                    ),
                    TextSpan(
                      text: 'out of 4',
                      style: TextStyle(color: Color(0xFF56555E)),
                    ),
                  ],
                )),
                padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                backButtonEnabled: true,
                onBackButtonPressed: () {
                  Navigator.pop(context);
                },
              ),
              LinearProgressIndicator(
                value: 2 / 3,
                color: ClientConfig.getColorScheme().secondary,
                backgroundColor: ClientConfig.getCustomColors().neutral200,
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose PIN',
                      style: ClientConfig.getTextStyleScheme().heading2,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Remember your PIN as you will use it for all future card purchases.',
                      style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
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
                              pageCleanupAndNavigate(
                                context,
                                fourDigitPinKey,
                                pin,
                                viewModel,
                                user,
                              );
                            } else {
                              highlightReasonAndResetScreen(
                                fourDigitPinKey,
                                user,
                                pin,
                              );
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
                  padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your PIN should not contain:',
                        textAlign: TextAlign.left,
                        style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                      ),
                      const SizedBox(height: 10),
                      PinValidityRule(
                        isValid: pinDiffersBirthDate,
                        text: 'Your date of birth',
                        icon: Icons.close,
                        validColor: const Color(0xFF15141E),
                        invalidColor: const Color(0xFFE61F27),
                      ),
                      PinValidityRule(
                        isValid: pinDiffersPostalCode,
                        text: 'Your postal code',
                        icon: Icons.close,
                        validColor: const Color(0xFF15141E),
                        invalidColor: const Color(0xFFE61F27),
                      ),
                      PinValidityRule(
                        isValid: pinIsNotASequence,
                        text: 'Number sequences, e.g. 1234',
                        icon: Icons.close,
                        validColor: const Color(0xFF15141E),
                        invalidColor: const Color(0xFFE61F27),
                      ),
                      PinValidityRule(
                        isValid: pinNotContainsRepeatingDigits,
                        text: 'More than two digits repeating',
                        icon: Icons.close,
                        validColor: const Color(0xFF15141E),
                        invalidColor: const Color(0xFFE61F27),
                      ),
                      const SizedBox(
                        height: 24,
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

  void highlightReasonAndResetScreen(
    GlobalKey<FourDigitPinCodeInputState> fourDigitPinKey,
    AuthenticatedUser user,
    String pin,
  ) {
    // Highlight reasons for an invalid pin
    highlightReasonsForInvalidPin(
      user.person.address!.postalCode!,
      user.person.birthDate!,
      pin,
    );

    // Toggle validity, clear pin, and set focus on first field
    fourDigitPinKey.currentState?.toggleValidity();
    fourDigitPinKey.currentState?.clearPin();
    fourDigitPinKey.currentState?.setFocusOnFirst();
  }

  void pageCleanupAndNavigate(
    BuildContext context,
    GlobalKey<FourDigitPinCodeInputState> fourDigitPinKey,
    String pin,
    BankCardViewModel viewModel,
    AuthenticatedUser user,
  ) {
    fourDigitPinKey.currentState?.unfocusAllFields();
    fourDigitPinKey.currentState?.setAllFieldsDone();
    markCompleted();

    Future.delayed(const Duration(milliseconds: 500), () {
      StoreProvider.of<AppState>(context).dispatch(
        BankCardChoosePinCommandAction(
          bankCard: viewModel.bankCard!,
          user: user,
          pin: pin,
        ),
      );
      Navigator.pushNamed(context, BankCardDetailsConfirmPinScreen.routeName);

      fourDigitPinKey.currentState?.clearPin();
      fourDigitPinKey.currentState?.setAllFieldsUndone();
      fourDigitPinKey.currentState?.setFocusOnFirst();
      restoreValidity();
      unmarkCompleted();
    });
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
      const Duration(milliseconds: 1000),
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

  void unmarkCompleted() {
    setState(() {
      completed = false;
    });
  }
}

class PinValidityRule extends StatelessWidget {
  final bool isValid;
  final String text;
  final IconData icon;
  final Color validColor;
  final Color invalidColor;

  const PinValidityRule({
    super.key,
    required this.isValid,
    required this.text,
    required this.icon,
    required this.validColor,
    required this.invalidColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 24,
          color: isValid ? validColor : invalidColor,
        ),
        Text(
          text,
          style:
              ClientConfig.getTextStyleScheme().bodyLargeRegular.copyWith(color: isValid ? validColor : invalidColor),
        ),
      ],
    );
  }
}
