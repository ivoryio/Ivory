import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';
import 'package:solarisdemo/infrastructure/bank_card/bank_card_presenter.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/screens/wallet/card_details/card_details_apple_wallet.dart';
import 'package:solarisdemo/screens/wallet/card_details/card_details_choose_pin.dart';
import 'package:solarisdemo/utilities/validator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/pin_field.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';


class BankCardDetailsConfirmPinScreen extends StatefulWidget {
  static const routeName = '/bankCardDetailsConfirmPinScreen';

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
    AuthenticatedUser user = context.read<AuthCubit>().state.user!;
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
                  children: const <TextSpan>[
                    TextSpan(
                      text: 'Step 3 ',
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
                backButtonEnabled: true,
                onBackButtonPressed: () {
                  Navigator.pop(context, );
                },
              ),
              LinearProgressIndicator(
                value: 3 / 3,
                color:  ClientConfig.getColorScheme().secondary,
                backgroundColor: const Color(0xFFE9EAEB),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: ClientConfig.getCustomClientUiSettings()
                      .defaultScreenHorizontalPadding,
                  right: ClientConfig.getCustomClientUiSettings()
                      .defaultScreenHorizontalPadding,
                  top: ClientConfig.getCustomClientUiSettings()
                      .defaultScreenVerticalPadding,
                ),
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
                  padding: EdgeInsets.only(
                    left: ClientConfig.getCustomClientUiSettings()
                        .defaultScreenHorizontalPadding,
                    right: ClientConfig.getCustomClientUiSettings()
                        .defaultScreenHorizontalPadding,
                    bottom: ClientConfig.getCustomClientUiSettings()
                        .defaultScreenVerticalPadding,
                  ),
                  child: PinValidityRule(
                    isValid: twoPinsMatch,
                    text: 'Your PIN should match',
                    icon: Icons.check,
                    validColor: completed
                        ? const Color(0xFF00774C)
                        : const Color(0xFF15141E),
                    invalidColor: const Color(0xFFE61F27),
                  ))
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
