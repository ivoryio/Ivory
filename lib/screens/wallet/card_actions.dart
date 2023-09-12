import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';
import 'package:solarisdemo/infrastructure/bank_card/bank_card_presenter.dart';
import 'package:solarisdemo/models/bank_card.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/bank_card/bank_card_action.dart';
import 'package:solarisdemo/screens/wallet/card_details/card_details_info.dart';
import 'package:solarisdemo/screens/wallet/card_details/card_details_screen.dart';
import 'package:solarisdemo/screens/wallet/change_pin/card_change_pin_choose_screen.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/ivory_list_item_with_action.dart';
import 'package:solarisdemo/widgets/spaced_column.dart';

class CardActions extends StatelessWidget {
  final String initialCardId;

  const CardActions({
    super.key,
    required this.initialCardId,
  });

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user!;

    return StoreConnector<AppState, BankCardViewModel>(
      onInit: (store) {
        store.dispatch(GetBankCardCommandAction(user: user, cardId: initialCardId));
      },
      converter: (store) {
        return BankCardPresenter.presentBankCard(
          bankCardState: store.state.bankCardState,
          user: user,
        );
      },
      builder: (context, viewModel) {
        return Padding(
          padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
          child: (() {
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
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }()),
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
    return Column(
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
            disabledColor: const Color(0xFFDFE2E6),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CardOptionsButton(
              icon: Icons.remove_red_eye_outlined,
              textLabel: 'Details',
              onPressed: () async {
                  Navigator.pushNamed(
                    context,
                    BankCardDetailsScreen.routeName,
                    arguments: CardDetailsScreenParams(card: viewModel.bankCard!),
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
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 40),
        SpacedColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          space: 28,
          children: [
            const ItemTitle(
              nameOfActionTitle: 'Security settings',
            ),
            IvoryListItemWithAction(
              leftIcon: Icons.dialpad,
              actionName: 'Change PIN',
              actionDescription: 'For security or personal reasons',
              rightIcon: Icons.arrow_forward_ios,
              actionSwitch: false,
              onPressed: () => Navigator.pushNamed(
                context,
                BankCardChangePinChooseScreen.routeName,
              ),
            ),
            IvoryListItemWithAction(
              leftIcon: Icons.lock_open,
              actionName: 'Unblock card',
              actionDescription: 'After 3 incorrect PIN/CVV attempts',
              rightIcon: Icons.arrow_forward_ios,
              actionSwitch: false,
            ),
            IvoryListItemWithAction(
              leftIcon: Icons.wifi_tethering_error,
              actionName: 'Contactless limit',
              actionDescription: 'For safe and mindful in-store payments',
              rightIcon: Icons.arrow_forward_ios,
              actionSwitch: false,
            ),
            IvoryListItemWithAction(
              leftIcon: Icons.wifi_tethering,
              actionName: 'Contactless payments',
              actionDescription: 'Apple Pay won’t be affected',
              rightIcon: Icons.arrow_forward_ios,
            ),
            IvoryListItemWithAction(
              leftIcon: Icons.language,
              actionName: 'Online payments',
              actionDescription: 'Apple Pay won’t be affected',
              rightIcon: Icons.arrow_forward_ios,
            ),
            IvoryListItemWithAction(
              leftIcon: Icons.payments,
              actionName: 'ATM withdrawals',
              actionDescription: 'If you don’t plan to withdraw',
              rightIcon: Icons.arrow_forward_ios,
            ),
            const ItemTitle(nameOfActionTitle: 'Card management'),
            IvoryListItemWithAction(
              leftIcon: Icons.credit_card,
              actionName: 'Replace card',
              actionDescription: 'If your card is damaged',
              rightIcon: Icons.arrow_forward_ios,
              actionSwitch: false,
            ),
            IvoryListItemWithAction(
              leftIcon: Icons.delete,
              actionName: 'Close card',
              actionDescription: 'The card will be permanently closed',
              rightIcon: Icons.arrow_forward_ios,
              actionSwitch: false,
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

class ItemTitle extends StatelessWidget {
  final String nameOfActionTitle;

  const ItemTitle({super.key, required this.nameOfActionTitle});

  @override
  Widget build(BuildContext context) {
    return Text(
      nameOfActionTitle,
      style: ClientConfig.getTextStyleScheme().labelLarge,
    );
  }
}
