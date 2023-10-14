import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';
import 'package:solarisdemo/infrastructure/bank_card/bank_card_presenter.dart';
import 'package:solarisdemo/models/bank_card.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/bank_card/bank_card_action.dart';
import 'package:solarisdemo/screens/settings/device_pairing/settings_device_pairing_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/card_details_widget.dart';
import 'package:solarisdemo/widgets/circular_countdown_progress_widget.dart';
import 'package:solarisdemo/screens/home/home_screen.dart';
import 'package:solarisdemo/widgets/modal.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

class CardScreenParams {
  final BankCard card;

  CardScreenParams({required this.card});
}

class BankCardDetailsScreen extends StatelessWidget {
  final CardScreenParams params;
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
              onBackButtonPressed: () async {
                Navigator.popUntil(context, ModalRoute.withName(HomeScreen.routeName));
                StoreProvider.of<AppState>(context).dispatch(
                  GetBankCardCommandAction(
                    user: user,
                    cardId: params.card.id,
                    forceReloadCardData: false,
                  ),
                );
              },
            ),
            StoreConnector<AppState, BankCardViewModel>(
              converter: (store) => BankCardPresenter.presentBankCard(
                bankCardState: store.state.bankCardState,
                user: user,
              ),
              onDidChange: (previousViewModel, viewModel) async => {
                if (previousViewModel is BankCardLoadingViewModel && viewModel is BankCardNoBoundedDevicesViewModel)
                  _showDevicePairingMissingModal(
                    context: context,
                    user: user,
                  ),
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
                          cardType: viewModel.bankCard?.type,
                          cardTypeLabel: 'Physical card',
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
                                      forceReloadCardData: false,
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
                                  forceReloadCardData: false,
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

  Future<void> _showDevicePairingMissingModal({
    required BuildContext context,
    required AuthenticatedUser user,
  }) async {
    bool devicePairedBottomSheetConfirmed = false;

    await showBottomModal(
      context: context,
      title: "Device pairing required",
      textWidget: RichText(
        text: TextSpan(
          style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
          children: [
            const TextSpan(
              text:
                  'In order to view your card details, you need to pair your device first. Click on the button below, or go to “Device pairing” under Security in the Settings tab and ',
            ),
            TextSpan(
              text: 'pair your device now.',
              style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
            ),
          ],
        ),
      ),
      content: Column(
        children: [
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              text: 'Go to “Device pairing”',
              onPressed: () async {
                devicePairedBottomSheetConfirmed = true;
                Navigator.pushNamed(context, SettingsDevicePairingScreen.routeName);
              },
            ),
          ),
        ],
      ),
    );

    if (!devicePairedBottomSheetConfirmed) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      StoreProvider.of<AppState>(context).dispatch(
        GetBankCardCommandAction(
          user: user,
          cardId: params.card.id,
          forceReloadCardData: false,
        ),
      );
    }
  }
}
