import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';

import '../../config.dart';
import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../infrastructure/bank_card/bank_card_presenter.dart';
import '../../redux/app_state.dart';
import '../../redux/bank_card/bank_card_action.dart';
import '../../widgets/button_with_icon.dart';
import '../../widgets/ivory_error_widget.dart';
import '../../widgets/screen_scaffold.dart';
import 'card_details_activation_success_screen.dart';

class BankCardDetailsAppleWalletScreen extends StatelessWidget {
  static const routeName = '/bankCardDetailsAppleWalletScreen';

  const BankCardDetailsAppleWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthenticatedUser user = context.read<AuthCubit>().state.user!;

    return ScreenScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppToolbar(
            padding: EdgeInsets.symmetric(
              horizontal: ClientConfig.getCustomClientUiSettings()
                  .defaultScreenHorizontalPadding,
            ),
            backButtonEnabled: false,
            onBackButtonPressed: () {
              Navigator.pop(context);
            },
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
                    padding: ClientConfig.getCustomClientUiSettings()
                        .defaultScreenPadding,
                    child: Column(
                      children: [
                        const Text(
                          'Add your credit card to Apple Wallet',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            height: 32 / 24,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          'Add your Porsche credit card to Apple Wallet to start making seamless POS purchases.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 24 / 16,
                          ),
                        ),
                        const SizedBox(
                          height: 160,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                                'assets/images/apple_wallet_logo.svg')
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 23.0),
                                text: 'Maybe later',
                                textStyle: const TextStyle(
                                  color: Color(0xFF2575FC),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                onPressed: () {
                                  StoreProvider.of<AppState>(context)
                                      .dispatch(BankCardActivateCommandAction(
                                    cardId: viewModel.bankCard!.id,
                                    user: user,
                                  ));
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            ButtonWithIcon(
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
                              iconWidget: Image.asset(
                                  'assets/icons/apple_wallet_logo.png'),
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