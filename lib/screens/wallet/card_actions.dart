import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:solarisdemo/cubits/card_details_cubit/card_details_cubit.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/screens/wallet/card_details_screen.dart';
import 'package:solarisdemo/widgets/spaced_column.dart';

import '../../config.dart';
import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../infrastructure/bank_card/bank_card_presenter.dart';
import '../../infrastructure/device/device_binding_service.dart';
import '../../models/bank_card.dart';
import '../../redux/bank_card/bank_card_action.dart';
import '../../widgets/button.dart';
import '../../widgets/dialog.dart';
import '../../widgets/ivory_list_item_with_action.dart';
import 'card_details_info.dart';

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

// ignore: must_be_immutable
class _CardDetailsOptions extends StatefulWidget {
  BankCard card;

  _CardDetailsOptions({required this.card});

  @override
  State<_CardDetailsOptions> createState() => __CardDetailsOptionsState();
}

class __CardDetailsOptionsState extends State<_CardDetailsOptions> {
  void _buildPopup({required String title, required String content}) {
    showAlertDialog(
      context: context,
      message: content,
      onOkPressed: () => Navigator.pop(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final optionWidgets = [
      const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Card settings',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 18,
              height: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      const SizedBox(height: 19),
      SpacedColumn(
        space: 29,
        children: [
          const _CardOptionColumns(
            icon: Icons.key,
            fieldName: 'View PIN',
            visibleSwitch: false,
          ),
          const _CardOptionColumns(
            icon: Icons.lock_clock,
            fieldName: 'Unblock PIN',
            visibleSwitch: false,
          ),
          const _CardOptionColumns(
            icon: Icons.payments,
            fieldName: 'Spending limit',
            visibleSwitch: true,
          ),
          const Divider(
            color: Color(0xFFEEEEEE),
            thickness: 1,
          ),
          const _CardOptionColumns(
            icon: Icons.local_atm,
            fieldName: 'Spending limit',
            visibleSwitch: true,
          ),
          _CardOptionColumns(
            icon: Icons.payments,
            fieldName: 'Online payments',
            forMoreInfoTap: () => _buildPopup(
                title: 'Online payments',
                content: 'You can use your card to pay online. You can also disable this option.'),
            visibleSwitch: true,
          ),
          _CardOptionColumns(
            icon: Icons.atm,
            fieldName: 'ATM withdrawals',
            forMoreInfoTap: () => _buildPopup(
                title: 'ATM withdrawals',
                content: 'You can use your card to withdraw cash from ATMs. You can also disable this option.'),
            visibleSwitch: true,
          ),
          _CardOptionColumns(
            icon: Icons.contactless,
            fieldName: 'Contactless payments',
            forMoreInfoTap: () => _buildPopup(
                title: 'Contactless payments',
                content: 'You can use your card to pay contactless. You can also disable this option.'),
            visibleSwitch: true,
          ),
          const Divider(
            color: Color(0xFFEEEEEE),
            thickness: 1,
          ),
          if (widget.card.status == BankCardStatus.ACTIVE)
            GestureDetector(
              onTap: () async {
                context.read<BankCardDetailsCubit>().freezeCard(
                      widget.card.id,
                    );
              },
              child: const SizedBox(
                width: double.infinity,
                child: _CardOptionColumns(
                  icon: Icons.ac_unit,
                  fieldName: 'Freeze card',
                  visibleSwitch: false,
                ),
              ),
            ),
          if (widget.card.status == BankCardStatus.BLOCKED)
            GestureDetector(
              onTap: () async {
                context.read<BankCardDetailsCubit>().unfreezeCard(
                      widget.card.id,
                    );
              },
              child: const SizedBox(
                width: double.infinity,
                child: _CardOptionColumns(
                  icon: Icons.ac_unit,
                  fieldName: 'Unfreeze card',
                  visibleSwitch: false,
                ),
              ),
            ),
        ],
      ),
    ];
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 0),
      itemCount: optionWidgets.length,
      itemBuilder: (context, index) => optionWidgets[index],
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
    );
  }
}

class _CardOptionColumns extends StatelessWidget {
  final IconData icon;
  final String fieldName;
  final void Function()? forMoreInfoTap;
  final bool visibleSwitch;

  const _CardOptionColumns({
    required this.icon,
    required this.fieldName,
    this.forMoreInfoTap,
    required this.visibleSwitch,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 9),
                _CardOptionName(name: fieldName),
                const SizedBox(width: 9.7),
                if (forMoreInfoTap != null)
                  GestureDetector(
                    onTap: forMoreInfoTap,
                    child: const Icon(
                      Icons.help_outline,
                      color: Color(0xFFB9B9B9),
                    ),
                  ),
              ],
            ),
            if (visibleSwitch == true) const _CardOptionSwitch()
          ],
        )
      ],
    );
  }
}

class _CardOptionName extends StatelessWidget {
  final String name;

  const _CardOptionName({required this.name});

  @override
  Widget build(BuildContext context) {
    return Text(name,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontSize: 18,
          height: 1.19,
          fontWeight: FontWeight.w400,
        ));
  }
}

class _CardOptionSwitch extends StatefulWidget {
  const _CardOptionSwitch();

  @override
  State<_CardOptionSwitch> createState() => _CardOptionSwitchState();
}

class _CardOptionSwitchState extends State<_CardOptionSwitch> {
  bool _isSpendingLimitEnabled = false;

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
      width: 36.0,
      height: 20.0,
      activeColor: Theme.of(context).primaryColor,
      inactiveColor: const Color(0xFFB0B0B0),
      duration: const Duration(milliseconds: 50),
      toggleSize: 18.0,
      value: _isSpendingLimitEnabled,
      padding: 1.5,
      onToggle: (val) {
        setState(() {
          _isSpendingLimitEnabled = val;
        });
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
        SpacedColumn(
          space: 48,
          children: [
            SpacedColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              space: 16,
              children: const [
                Text(
                  'Activate your card',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    height: 1.33,
                  ),
                ),
                Text(
                  'Your card is currently inactive. \n\nOnce it arrives to your address, click on the "Activate my card" to active it and start using. \n\nIt will take only 1 minute.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          child: Button(
            text: "Activate my card",
            disabledColor: const Color(0xFFDFE2E6),
            color: const Color(0xFF2575FC),
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
                BiometricAuthentication biometricService =
                    BiometricAuthentication(message: 'Please use biometric authentication to view card details.');
                if (await biometricService.authenticateWithBiometrics()) {
                  // ignore: use_build_context_synchronously
                  Navigator.pushNamed(
                    context,
                    BankCardDetailsScreen.routeName,
                    arguments: CardDetailsScreenParams(card: viewModel.bankCard!),
                  );
                }
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
              nameOfActionTitle: 'Spending settings',
            ),
            IvoryListItemWithAction(
              leftIcon: Icons.speed_outlined,
              actionName: 'Spending cap',
              actionDescription: 'Set it up and get an alert if you exceed it',
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
            const ItemTitle(nameOfActionTitle: 'Security settings'),
            IvoryListItemWithAction(
              leftIcon: Icons.key,
              actionName: 'View PIN',
              actionDescription: 'For security or personal reasons',
              rightIcon: Icons.arrow_forward_ios,
              actionSwitch: false,
            ),
            IvoryListItemWithAction(
              leftIcon: Icons.dialpad,
              actionName: 'Change PIN',
              actionDescription: 'For security or personal reasons',
              rightIcon: Icons.arrow_forward_ios,
              actionSwitch: false,
            ),
            IvoryListItemWithAction(
              leftIcon: Icons.lock_open,
              actionName: 'Unblock card',
              actionDescription: 'After 3 incorrect PIN/CVV attempts',
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
            backgroundColor: Theme.of(context).colorScheme.primary,
            fixedSize: const Size(48, 48),
            shape: const CircleBorder(),
            splashFactory: NoSplash.splashFactory,
          ),
          child: Icon(
            icon,
            size: 24,
            color: Theme.of(context).colorScheme.background,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            textLabel,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              height: 1.125,
            ),
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
      style: const TextStyle(
        fontSize: 20,
        height: 1.4,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
