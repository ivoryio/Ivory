// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../../config.dart';
import '../../cubits/card_details_cubit/card_details_cubit.dart';
import '../../services/biometric_auth_service.dart';
import '../../services/device_service.dart';
import '../../widgets/button.dart';
import '../../widgets/card_widget.dart';
import '../../widgets/screen.dart';
import '../../widgets/spaced_column.dart';

class BankCardDetailsMainScreen extends StatelessWidget {
  const BankCardDetailsMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<BankCardDetailsCubit>().state;
    final id = state.card!.id;

    return Screen(
      scrollPhysics: const ClampingScrollPhysics(),
      title: 'Card',
      centerTitle: true,
      hideBackButton: true,
      hideBottomNavbar: false,
      child: Padding(
        padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
        child: FutureBuilder(
          future: CacheCardsIds.getCardIdFromCache(id),
          builder: (context, isInCache) => (isInCache.data == false)
              ? const InactiveCard()
              : const ActiveCard(),
        ),
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
              cardType: 'Credit card',
              // backgroundImageFile: 'porsche_logo.png',
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
            // onPressed: (state.card!.status == BankCardStatus.INACTIVE)
            //     ? () {
            //         context
            //             .read<BankCardDetailsCubit>()
            //             .initializeActivation(state.card!);
            //       }
            //     : null,
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

  void _loginWithFaceId(BuildContext context) async {
    final FaceIdAuthentication _faceIdAuthentication =
        FaceIdAuthentication(message: 'Authenticate to view card details');
    bool authenticated =
        await _faceIdAuthentication.authenticateWithBiometrics();
    if (authenticated) {
      Future.delayed(const Duration(milliseconds: 500), () {
        context
            .read<BankCardDetailsCubit>()
            .viewCardDetails(context.read<BankCardDetailsCubit>().state.card!);
      });
    } else {
      // Biometric authentication failed or was canceled.
      // You can show an error message or perform other actions.
      log('Biometric authentication failed or was canceled.');
    }
  }

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
              cardType: 'Credit card',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CardOptionsButton(
                  icon: Icons.remove_red_eye_outlined,
                  textLabel: 'Details',
                  onPressed: () => {
                    _loginWithFaceId(context),
                  },
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
                ItemTitle(
                  nameOfActionTitle: 'Spending settings',
                ),
                ItemName(
                  leftIcon: Icons.speed_outlined,
                  actionName: 'Spending cap',
                  actionDescription:
                      'Set it up and get an alert if you exceed it',
                  rightIcon: Icons.arrow_forward_ios,
                  actionSwitch: false,
                ),
                ItemName(
                  leftIcon: Icons.wifi_tethering_error,
                  actionName: 'Contactless limit',
                  actionDescription: 'For safe and mindful in-store payments',
                  rightIcon: Icons.arrow_forward_ios,
                  actionSwitch: false,
                ),
                ItemTitle(nameOfActionTitle: 'Security settings'),
                ItemName(
                  leftIcon: Icons.key,
                  actionName: 'View PIN',
                  actionDescription: 'For security or personal reasons',
                  rightIcon: Icons.arrow_forward_ios,
                  actionSwitch: false,
                ),
                ItemName(
                  leftIcon: Icons.dialpad,
                  actionName: 'Change PIN',
                  actionDescription: 'For security or personal reasons',
                  rightIcon: Icons.arrow_forward_ios,
                  actionSwitch: false,
                ),
                ItemName(
                  leftIcon: Icons.lock_open,
                  actionName: 'Unblock card',
                  actionDescription: 'After 3 incorrect PIN/CVV attempts',
                  rightIcon: Icons.arrow_forward_ios,
                  actionSwitch: false,
                ),
                ItemName(
                  leftIcon: Icons.wifi_tethering,
                  actionName: 'Contactless payments',
                  actionDescription: 'Apple Pay won\’t be affected',
                  rightIcon: Icons.arrow_forward_ios,
                ),
                ItemName(
                  leftIcon: Icons.language,
                  actionName: 'Online payments',
                  actionDescription: 'Apple Pay won\’t be affected',
                  rightIcon: Icons.arrow_forward_ios,
                ),
                ItemName(
                  leftIcon: Icons.payments,
                  actionName: 'ATM withdrawals',
                  actionDescription: 'If you don’t plan to withdraw',
                  rightIcon: Icons.arrow_forward_ios,
                ),
                ItemTitle(nameOfActionTitle: 'Card management'),
                ItemName(
                  leftIcon: Icons.credit_card,
                  actionName: 'Replace card',
                  actionDescription: 'If your card is damaged',
                  rightIcon: Icons.arrow_forward_ios,
                  actionSwitch: false,
                ),
                ItemName(
                  leftIcon: Icons.delete,
                  actionName: 'Close card',
                  actionDescription: 'The card will be permanently closed',
                  rightIcon: Icons.arrow_forward_ios,
                  actionSwitch: false,
                ),
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
            backgroundColor: ClientConfig.getColorScheme().primary,
            fixedSize: const Size(48, 48),
            shape: const CircleBorder(),
            splashFactory: NoSplash.splashFactory,
          ),
          child: Icon(
            icon,
            size: 24,
            color: ClientConfig.getColorScheme().background,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            textLabel,
            style: TextStyle(
              color: ClientConfig.getColorScheme().primary,
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
          fontSize: 20, height: 1.4, fontWeight: FontWeight.w600),
    );
  }
}

class ItemName extends StatelessWidget {
  final IconData leftIcon;
  final String actionName;
  final String actionDescription;
  final IconData rightIcon;
  final bool actionSwitch;

  const ItemName({
    super.key,
    required this.leftIcon,
    required this.actionName,
    required this.actionDescription,
    required this.rightIcon,
    this.actionSwitch = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(leftIcon, color: ClientConfig.getColorScheme().error, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          ),
        ),
        Container(
          padding: const EdgeInsets.only(right: 0),
          child: (actionSwitch == true)
              ? const ActionItem()
              : Icon(rightIcon,
                  color: ClientConfig.getColorScheme().primary, size: 24),
        ),
      ],
    );
  }
}

class ActionItem extends StatefulWidget {
  const ActionItem({super.key});

  @override
  State<ActionItem> createState() => _ActionItemState();
}

class _ActionItemState extends State<ActionItem> {
  bool _isSpendingLimitEnabled = false;

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
      width: 56.0,
      height: 32.0,
      activeColor: Theme.of(context).primaryColor,
      inactiveColor: const Color(0xFFB0B0B0),
      duration: const Duration(milliseconds: 50),
      toggleSize: 24.0,
      value: _isSpendingLimitEnabled,
      padding: 4,
      onToggle: (val) {
        setState(() {
          _isSpendingLimitEnabled = val;
          print('Switch Value ===> $val');
        });
      },
    );
  }
}
