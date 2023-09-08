import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/models/bank_card.dart';
import 'package:solarisdemo/screens/home/home_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/modal.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../config.dart';
import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../infrastructure/bank_card/bank_card_presenter.dart';
import '../../models/user.dart';
import '../../redux/app_state.dart';
import '../../redux/bank_card/bank_card_action.dart';
import '../../widgets/button.dart';
import '../../widgets/card_details_widget.dart';
import '../../widgets/circular_countdown_progress_widget.dart';

class CardDetailsScreenParams {
  final BankCard card;

  CardDetailsScreenParams({required this.card});
}

class BankCardDetailsScreen extends StatelessWidget {
  final CardDetailsScreenParams params;
  static const routeName = '/cardDetailsScreen';

  const BankCardDetailsScreen({super.key, required this.params});

  @override
  Widget build(BuildContext context) {
    AuthenticatedUser user = context.read<AuthCubit>().state.user!;

    return ScreenScaffold(
      body: Padding(
        padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppToolbar(
              title: 'View card details',
              onBackButtonPressed: () {
                Navigator.popUntil(context, ModalRoute.withName(HomeScreen.routeName));
                StoreProvider.of<AppState>(context).dispatch(
                  GetBankCardCommandAction(
                    user: user,
                    cardId: params.card.id,
                  ),
                );
              },
            ),
            StoreConnector<AppState, BankCardViewModel>(
              converter: (store) => BankCardPresenter.presentBankCard(
                bankCardState: store.state.bankCardState,
                user: user,
              ),
              onDidChange: (previousViewModel, viewModel) => {
                if (previousViewModel is BankCardLoadingViewModel && viewModel is BankCardNoBoundedDevicesViewModel)
                  {
                    showBottomModal(
                      context: context,
                      title: "Device pairing required",
                      message:
                          "In order to access the card details you need to pair your device first. You can do this from the “Security” menu in the Settings tab.",
                      content: Column(
                        children: [
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: PrimaryButton(
                              text: 'OK',
                              onPressed: () {
                                Navigator.popUntil(context, ModalRoute.withName(HomeScreen.routeName));
                                StoreProvider.of<AppState>(context).dispatch(GetBankCardCommandAction(
                                  user: context.read<AuthCubit>().state.user!,
                                  cardId: params.card.id,
                                ));
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  }
              },
              onInit: (store) => {
                store.dispatch(
                  BankCardFetchDetailsCommandAction(
                    user: user,
                    bankCard: params.card,
                  ),
                ),
              },
              builder: (context, viewModel) {
                if (viewModel is BankCardLoadingViewModel) {
                  return const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    ),
                  );
                }
                if (viewModel is BankCardErrorViewModel) {
                  return const Center(
                    child: Text('Error'),
                  );
                }
                if (viewModel is BankCardDetailsFetchedViewModel) {
                  return Flexible(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        BankCardShowDetailsWidget(
                          cardDetails: viewModel.cardDetails!,
                          cardType: 'Physical card',
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                'This information will be displayed for 60 seconds.',
                                style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              width: 70,
                              height: 70,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(0.0),
                              child: CircularCountdownProgress(
                                onCompleted: () {
                                  Navigator.pop(context);
                                  StoreProvider.of<AppState>(context).dispatch(
                                    GetBankCardCommandAction(
                                      user: user,
                                      cardId: params.card.id,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: Button(
                            disabledColor: const Color(0xFFDFE2E6),
                            color: ClientConfig.getColorScheme().tertiary,
                            textColor: ClientConfig.getColorScheme().surface,
                            text: 'Back to "Card"',
                            onPressed: () {
                              Navigator.pop(context);
                              StoreProvider.of<AppState>(context).dispatch(
                                GetBankCardCommandAction(
                                  user: user,
                                  cardId: params.card.id,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const Expanded(
                  child: Center(
                      child: CircularProgressIndicator(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
