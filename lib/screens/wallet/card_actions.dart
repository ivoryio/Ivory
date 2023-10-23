import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/bank_card/bank_card_presenter.dart';
import 'package:solarisdemo/models/bank_card.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/bank_card/bank_card_action.dart';
import 'package:solarisdemo/redux/bank_card/bank_card_state.dart';
import 'package:solarisdemo/screens/wallet/card_activation/card_activation_info.dart';
import 'package:solarisdemo/screens/wallet/card_details/card_details_screen.dart';
import 'package:solarisdemo/screens/wallet/change_pin/card_change_pin_choose_screen.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/ivory_list_tile.dart';
import 'package:solarisdemo/widgets/ivory_switch.dart';

import '../../widgets/ivory_list_title.dart';

class CardActions extends StatelessWidget {
  final String initialCardId;

  const CardActions({
    super.key,
    required this.initialCardId,
  });

  @override
  Widget build(BuildContext context) {
    final user =
        (StoreProvider.of<AppState>(context).state.authState as AuthenticatedState).authenticatedUser;

    return StoreConnector<AppState, BankCardViewModel>(
      onInit: (store) {
        store.dispatch(
          GetBankCardCommandAction(
            user: user,
            cardId: initialCardId,
            forceReloadCardData: false,
          ),);
      },
      converter: (store) {
        return BankCardPresenter.presentBankCard(
          bankCardState: store.state.bankCardState,
          user: user,
        );
      },
      builder: (context, viewModel) {
        if (viewModel is BankCardInitialViewModel) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (viewModel is BankCardLoadingViewModel) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (viewModel is BankCardErrorViewModel) {
          return const Text("Something went wrong");
        }
        if (viewModel is BankCardFetchedViewModel) {
          if (viewModel.bankCard!.status == BankCardStatus.ACTIVE) {
            return ActiveCard(
              viewModel: viewModel,
            );
          }
          if (viewModel.bankCard!.status == BankCardStatus.INACTIVE) {
            return InactiveCard(
              viewModel: viewModel,
            );
          }
          if (viewModel.bankCard!.status == BankCardStatus.BLOCKED) {
            return FrozenCard(
              viewModel: viewModel,
            );
          }
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class InactiveCard extends StatelessWidget {
  final BankCardFetchedViewModel viewModel;
  const InactiveCard({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Activate your card',
                style: ClientConfig.getTextStyleScheme().heading3,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'Your card is currently inactive. \n\nOnce it arrives to your address, click on the "Activate my card" to active it and start using. \n\nIt will take only 1 minute.',
                style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
              ),
              const SizedBox(height: 60),
            ],
          ),
          const SizedBox(
            height: 70,
          ),
          SizedBox(
            width: double.infinity,
            child: Button(
              text: "Activate my card",
              disabledColor: ClientConfig.getCustomColors().neutral300,
              color: ClientConfig.getColorScheme().tertiary,
              textColor: ClientConfig.getColorScheme().surface,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  BankCardDetailsInfoScreen.routeName,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ActiveCard extends StatelessWidget {
  final BankCardFetchedViewModel viewModel;
  const ActiveCard({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CardOptionsButton(
                icon: Icons.remove_red_eye_outlined,
                textLabel: 'Details',
                onPressed: () async {
                  Navigator.pushNamed(
                    context,
                    BankCardDetailsScreen.routeName,
                    arguments: CardScreenParams(card: viewModel.bankCard!),
                  );
                },
              ),
              CardOptionsButton(
                icon: Icons.wallet,
                textLabel: 'Add to wallet',
                onPressed: () {},
              ),
              CardOptionsButton(
                icon: Icons.speed,
                textLabel: 'Set cap',
                onPressed: () => {},
              ),
              CardOptionsButton(
                icon: Icons.ac_unit,
                textLabel: 'Freeze',
                onPressed: () {
                  StoreProvider.of<AppState>(context).dispatch(
                    BankCardFreezeCommandAction(
                      bankCards:
                          (StoreProvider.of<AppState>(context).state.bankCardsState as BankCardsFetchedState).bankCards,
                      user: viewModel.user!,
                      bankCard: viewModel.bankCard!,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const IvoryListTitle(title: 'Security settings'),
            IvoryListTile(
              leftIcon: Icons.dialpad,
              title: 'Change PIN',
              subtitle: 'For security or personal reasons',
              rightIcon: Icons.arrow_forward_ios,
              onTap: () => Navigator.pushNamed(
                context,
                BankCardChangePinChooseScreen.routeName,
                arguments: CardScreenParams(card: viewModel.bankCard!),
              ),
            ),
            const IvoryListTile(
              leftIcon: Icons.lock_open,
              title: 'Unblock card',
              subtitle: 'After 3 incorrect PIN/CVV attempts',
              rightIcon: Icons.arrow_forward_ios,
            ),
            const IvoryListTile(
              leftIcon: Icons.wifi_tethering_error,
              title: 'Contactless limit',
              subtitle: 'For safe and mindful in-store payments',
              rightIcon: Icons.arrow_forward_ios,
            ),
            const IvoryListTile(
              leftIcon: Icons.wifi_tethering,
              title: 'Contactless payments',
              subtitle: 'Apple Pay won’t be affected',
              rightIcon: Icons.arrow_forward_ios,
              actionItem: IvorySwitch(),
            ),
            const IvoryListTile(
              leftIcon: Icons.language,
              title: 'Online payments',
              subtitle: 'Apple Pay won’t be affected',
              rightIcon: Icons.arrow_forward_ios,
              actionItem: IvorySwitch(),
            ),
            const IvoryListTile(
              leftIcon: Icons.payments,
              title: 'ATM withdrawals',
              subtitle: 'If you don’t plan to withdraw',
              rightIcon: Icons.arrow_forward_ios,
              actionItem: IvorySwitch(),
            ),
            const SizedBox(height: 16),
            const IvoryListTitle(title: 'Card management'),
            const IvoryListTile(
              leftIcon: Icons.credit_card,
              title: 'Replace card',
              subtitle: 'If your card is damaged',
              rightIcon: Icons.arrow_forward_ios,
            ),
            const IvoryListTile(
              leftIcon: Icons.delete_outline,
              title: 'Close card',
              subtitle: 'The card will be permanently closed',
              rightIcon: Icons.arrow_forward_ios,
            ),
            const SizedBox(height: 16)
          ],
        )
      ],
    );
  }
}

class FrozenCard extends StatelessWidget {
  final BankCardFetchedViewModel viewModel;
  const FrozenCard({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CardOptionsButton(
              icon: Icons.ac_unit,
              textLabel: 'Unfreeze',
              onPressed: () async {
                StoreProvider.of<AppState>(context).dispatch(
                  BankCardUnfreezeCommandAction(
                    user: viewModel.user!,
                    bankCard: viewModel.bankCard!,
                    bankCards:
                        (StoreProvider.of<AppState>(context).state.bankCardsState as BankCardsFetchedState).bankCards,
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 40),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const IvoryListTitle(title: 'If your card is compromised'),
            if (viewModel.bankCard!.type.toString().contains('virtual')) const SizedBox(height: 28),
            if (viewModel.bankCard!.type.toString().contains('virtual'))
              const IvoryListTile(
                leftIcon: Icons.credit_card,
                title: 'Replace card',
                subtitle: 'If your card is damaged',
                rightIcon: Icons.arrow_forward_ios,
              ),
            const IvoryListTile(
              leftIcon: Icons.delete_outline,
              title: 'Close card',
              subtitle: 'The card will be permanently closed',
              rightIcon: Icons.arrow_forward_ios,
            ),
          ],
        )
      ],
    );
  }
}

class CardOptionsButton extends StatelessWidget {
  final IconData icon;
  final String textLabel;
  final Function onPressed;

  const CardOptionsButton({super.key, required this.icon, required this.textLabel, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => onPressed(),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF15141E),
            fixedSize: const Size(48, 48),
            shape: const CircleBorder(),
            splashFactory: NoSplash.splashFactory,
          ),
          child: Icon(
            icon,
            size: 24,
            color: ClientConfig.getColorScheme().surface,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            textLabel,
            style: ClientConfig.getTextStyleScheme().labelSmall.copyWith(color: const Color(0xFF15141E)),
          ),
        )
      ],
    );
  }
}
