import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/bank_card/bank_card_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/screens/wallet/card_activation/card_activation_apple_wallet.dart';
import 'package:solarisdemo/screens/wallet/card_activation/card_activation_choose_pin.dart';
import 'package:solarisdemo/utilities/validator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/pin_field.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

class BankCardDetailsConfirmPinScreen extends StatefulWidget {
  static const routeName = '/bankCardDetailsConfirmPinScreen';

  const BankCardDetailsConfirmPinScreen({super.key});

  @override
  State<BankCardDetailsConfirmPinScreen> createState() => _BankCardDetailsConfirmPinScreenState();
}

class _BankCardDetailsConfirmPinScreenState extends State<BankCardDetailsConfirmPinScreen> {
  late bool twoPinsMatch = true;
  late bool completed = false;
  GlobalKey<FourDigitPinCodeInputState> fourDigitPinKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final user =
        (StoreProvider.of<AppState>(context).state.authState as AuthenticatedState).authenticatedUser;
    return StoreConnector<AppState, BankCardViewModel>(
      converter: (store) => BankCardPresenter.presentBankCard(
        user: user,
        bankCardState: store.state.bankCardState,
      ),
      builder: (context, viewModel) {
        return ScreenScaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppToolbar(
                richTextTitle: RichText(
                    text: TextSpan(
                  style: ClientConfig.getTextStyleScheme().heading4,
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'Step 3 ',
                    ),
                    TextSpan(
                      text: 'out of 4',
                      style: TextStyle(color: ClientConfig.getCustomColors().neutral700),
                    ),
                  ],
                )),
                padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                backButtonEnabled: true,
                onBackButtonPressed: () {
                  Navigator.pop(
                    context,
                  );
                },
              ),
              LinearProgressIndicator(
                value: 3 / 3,
                color: ClientConfig.getColorScheme().secondary,
                backgroundColor: ClientConfig.getCustomColors().neutral200,
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Confirm PIN',
                              style: ClientConfig.getTextStyleScheme().heading2,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Confirm your PIN by typing it again.',
                              style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FourDigitPinCodeInput(
                          key: fourDigitPinKey,
                          onCompleted: (confirmPin) {
                            if (isPinValid(
                              viewModel.pin!,
                              confirmPin,
                            )) {
                              fourDigitPinKey.currentState?.unfocusAllFields();
                              fourDigitPinKey.currentState?.setAllFieldsDone();
                              markCompleted();
                              Future.delayed(
                                const Duration(
                                  milliseconds: 500,
                                ),
                                () {
                                  Navigator.pushNamed(
                                    context,
                                    BankCardDetailsAppleWalletScreen.routeName,
                                  );
                                },
                              );
                            } else {
                              highlightReasonsForInvalidPin(
                                viewModel.pin!,
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
              ),
              const Spacer(),
              Padding(
                padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                child: Column(
                  children: [
                    PinValidityRule(
                      isValid: twoPinsMatch,
                      text: 'Your PIN should match',
                      icon: Icons.check,
                      validColor: completed ? ClientConfig.getCustomColors().success : ClientConfig.getCustomColors().neutral900,
                      invalidColor: const Color(0xFFE61F27),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
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
      twoPinsMatch = true;
    });
  }

  void markCompleted() {
    setState(() {
      completed = true;
    });
  }
}
