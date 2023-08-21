import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../config.dart';
import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../infrastructure/bank_card/bank_card_presenter.dart';
import '../../models/user.dart';
import '../../redux/app_state.dart';
import '../../utilities/validator.dart';
import '../../widgets/pin_field.dart';
import 'card_details_apple_wallet.dart';

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
                    text: const TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Step 3 ',
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
                value: 3 / 4,
                color: Color(0xFF2575FC),
                backgroundColor: Color(0xFFE9EAEB),
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
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        SizedBox(
                          height: 16,
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
                child: Row(
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
