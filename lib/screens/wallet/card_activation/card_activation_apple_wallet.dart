import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/bank_card/bank_card_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/bank_card/bank_card_action.dart';
import 'package:solarisdemo/screens/wallet/card_activation/card_activation_success_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/button_with_icon.dart';
import 'package:solarisdemo/widgets/ivory_error_widget.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

class BankCardDetailsAppleWalletScreen extends StatelessWidget {
  static const routeName = '/bankCardDetailsAppleWalletScreen';

  const BankCardDetailsAppleWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user =
        (StoreProvider.of<AppState>(context).state.authState as AuthenticatedState).authenticatedUser;

    return ScreenScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppToolbar(
            richTextTitle: RichText(
              text: TextSpan(
                style: ClientConfig.getTextStyleScheme().heading4,
                children: <TextSpan>[
                  const TextSpan(
                    text: 'Step 4 ',
                  ),
                  TextSpan(
                    text: 'out of 4',
                    style: TextStyle(color: ClientConfig.getCustomColors().neutral700),
                  ),
                ],
              ),
            ),
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            backButtonEnabled: false,
            onBackButtonPressed: () {
              Navigator.pop(context);
            },
          ),
          LinearProgressIndicator(
            value: 4 / 4,
            color: ClientConfig.getColorScheme().secondary,
            backgroundColor: ClientConfig.getCustomColors().neutral200,
          ),
          const SizedBox(
            height: 16,
          ),
          StoreConnector<AppState, BankCardViewModel>(
              converter: (store) => BankCardPresenter.presentBankCard(
                    bankCardState: store.state.bankCardState,
                    user: user,
                  ),
              onDidChange: (previousViewModel, viewModel) {
                if (viewModel is BankCardActivatedViewModel) {
                  Navigator.pushNamed(
                    context,
                    BankCardDetailsActivationSuccessScreen.routeName,
                  );
                }
              },
              builder: (context, viewModel) {
                if (viewModel is BankCardLoadingViewModel) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (viewModel is BankCardErrorViewModel) {
                  return const IvoryErrorWidget(
                    'Error activating the card',
                  );
                }
                return Expanded(
                  child: Padding(
                    padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
                    child: Column(
                      children: [
                        Text(
                          'Add your credit card to Apple Wallet',
                          style: ClientConfig.getTextStyleScheme().heading2,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Add your Porsche credit card to Apple Wallet to start making seamless POS purchases.',
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                        ),
                        const SizedBox(
                          height: 160,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/apple_wallet_logo.svg',
                            )
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Button(
                                color: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 23.0),
                                text: 'Maybe later',
                                textStyle: ClientConfig.getTextStyleScheme()
                                    .bodyLargeRegular
                                    .copyWith(color: ClientConfig.getColorScheme().tertiary),
                                onPressed: () {
                                  StoreProvider.of<AppState>(context).dispatch(BankCardActivateCommandAction(
                                    cardId: (viewModel as BankCardPinChoosenViewModel).bankCard!.id,
                                  ));
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: ButtonWithIcon(
                                text: 'Add to Apple Wallet',
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                onPressed: () {
                                  //TODO: Add to apple wallet flow
                                },
                                iconWidget: Image.asset('assets/icons/apple_wallet_logo.png'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }
}
