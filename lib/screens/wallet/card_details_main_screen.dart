import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/card_details_cubit/card_details_cubit.dart';
import '../../models/bank_card.dart';
import '../../themes/default_theme.dart';
import '../../widgets/button.dart';
import '../../widgets/card_widget.dart';
import '../../widgets/screen.dart';
import '../../widgets/spaced_column.dart';

class BankCardDetailsMainScreen extends StatelessWidget {
  const BankCardDetailsMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<BankCardDetailsCubit>().state;

    return Screen(
      scrollPhysics: const ClampingScrollPhysics(),
      title: 'Card',
      centerTitle: true,
      hideBackButton: true,
      hideBottomNavbar: false,
      child: Padding(
        padding: defaultScreenPadding,
        child: (state.card!.status == BankCardStatus.INACTIVE)
            ? const InactiveCard()
            : const ActiveCard(),
      ),
    );
  }
}

class InactiveCard extends StatelessWidget {
  const InactiveCard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<BankCardDetailsCubit>().state;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpacedColumn(
          space: 48,
          children: [
            BankCardWidget(
              cardNumber: state.card!.representation!.maskedPan!,
              cardHolder: state.card!.representation!.line2 ?? 'data missing',
              cardExpiry: state.card!.representation!.formattedExpirationDate!,
              isViewable: false,
            ),
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
        SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            text: "Activate my card",
            onPressed: () {
              context
                  .read<BankCardDetailsCubit>()
                  .initializeActivation(state.card!);
            },
          ),
        ),
      ],
    );
  }
}

class ActiveCard extends StatelessWidget {
  const ActiveCard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<BankCardDetailsCubit>().state;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpacedColumn(
          space: 16,
          children: [
            BankCardWidget(
              cardNumber: state.card!.representation!.maskedPan!,
              cardHolder: state.card!.representation!.line2 ?? 'data missing',
              cardExpiry: state.card!.representation!.formattedExpirationDate!,
              isViewable: false,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CardOptionsButton(
                  icon: Icons.remove_red_eye_outlined,
                  textLabel: 'Details',
                  onPressed: () => {},
                ),
                CardOptionsButton(
                  icon: Icons.wallet,
                  textLabel: 'Add to wallet',
                  onPressed: () => {},
                ),
                CardOptionsButton(
                  icon: Icons.speed,
                  textLabel: 'Set cap',
                  onPressed: () => {},
                ),
                CardOptionsButton(
                  icon: Icons.ac_unit,
                  textLabel: 'Freeze',
                  onPressed: () => {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            SpacedColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              space: 16,
              children: const [
                CardActionTitle(
                  nameOfActionTitle: 'Spending settings',
                ),
                CardAction(
                    icon: Icons.speed_outlined,
                    actionName: 'Spending cap',
                    actionDescription:
                        'Set it up and get an alert if you exceed it'),
                CardAction(
                    icon: Icons.speed_outlined,
                    actionName: 'Contactless limit',
                    actionDescription:
                        'For safe and mindful in-store payments'),
                CardActionTitle(nameOfActionTitle: 'Security settings'),
                CardAction(
                    icon: Icons.speed_outlined,
                    actionName: 'View PIN',
                    actionDescription: 'For security or personal reasons'),
                CardAction(
                    icon: Icons.speed_outlined,
                    actionName: 'Change PIN',
                    actionDescription: 'For security or personal reasons'),
                CardAction(
                    icon: Icons.speed_outlined,
                    actionName: 'Unblock card',
                    actionDescription: 'After 3 incorrect PIN/CVV attempts'),
                CardAction(
                    icon: Icons.speed_outlined,
                    actionName: 'Contactless payments',
                    actionDescription: 'Apple Pay won\’t be affected'),
                CardAction(
                    icon: Icons.speed_outlined,
                    actionName: 'Online payments',
                    actionDescription: 'Apple Pay won\’t be affected'),
                CardAction(
                    icon: Icons.speed_outlined,
                    actionName: 'ATM withdrawals',
                    actionDescription: 'If you don’t plan to withdraw'),
                CardActionTitle(nameOfActionTitle: 'Card management'),
                CardAction(
                    icon: Icons.speed_outlined,
                    actionName: 'Replace card',
                    actionDescription: 'If your card is damaged'),
              ],
            )
          ],
        ),
      ],
    );
  }
}

class CardOptionsButton extends StatelessWidget {
  final IconData icon;
  final String textLabel;
  final Function onPressed;

  const CardOptionsButton(
      {super.key,
      required this.icon,
      required this.textLabel,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => onPressed(),
          style: ElevatedButton.styleFrom(
            backgroundColor: defaultColorScheme.primary,
            fixedSize: const Size(48, 48),
            shape: const CircleBorder(),
            splashFactory: NoSplash.splashFactory,
          ),
          child: Icon(
            icon,
            size: 24,
            color: defaultColorScheme.background,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            textLabel,
            style: TextStyle(
              color: defaultColorScheme.primary,
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

class CardActionTitle extends StatelessWidget {
  final String nameOfActionTitle;

  const CardActionTitle({super.key, required this.nameOfActionTitle});

  @override
  Widget build(BuildContext context) {
    return Text(
      nameOfActionTitle,
      style: const TextStyle(
          fontSize: 20, height: 1.4, fontWeight: FontWeight.w600),
    );
  }
}

class CardAction extends StatelessWidget {
  final IconData icon;
  final String actionName;
  final String actionDescription;

  const CardAction({
    super.key,
    required this.icon,
    required this.actionName,
    required this.actionDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: defaultColorScheme.error, size: 24),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              actionName,
              style: const TextStyle(
                  fontSize: 16, height: 1.5, fontWeight: FontWeight.w600),
            ),
            Text(
              actionDescription,
              style: const TextStyle(
                  fontSize: 14, height: 1.29, fontWeight: FontWeight.w400),
            ),
          ],
        )
      ],
    );
  }
}
