import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:solarisdemo/cubits/card_details_cubit/card_details_cubit.dart';
import 'package:solarisdemo/cubits/card_details_cubit/card_details_state.dart';
import 'package:solarisdemo/screens/wallet/card_details_activation_success_screen.dart';
import 'package:solarisdemo/services/card_service.dart';
import 'package:solarisdemo/widgets/spaced_column.dart';

import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../models/bank_card.dart';
import '../../models/user.dart';
import '../../router/routing_constants.dart';
import '../../widgets/dialog.dart';
import '../../widgets/screen.dart';
import 'card_activated_screen.dart';
import 'card_details_apple_wallet_screen.dart';
import 'card_details_choose_pin_screen.dart';
import 'card_details_confirm_pin_screen.dart';
import 'card_details_info_screen.dart';
import 'card_details_main_screen.dart';

class CardDetailsScreen extends StatelessWidget {
  final BankCard card;

  const CardDetailsScreen({
    super.key,
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    AuthenticatedUser user = context.read<AuthCubit>().state.user!;
    return BlocProvider.value(
      value: BankCardDetailsCubit(
        cardsService: BankCardsService(user: user.cognito),
      )..loadCard(card.id),
      child: BlocBuilder<BankCardDetailsCubit, BankCardDetailsState>(
        builder: (context, state) {
          if (state is BankCardDetailsLoadingState) {
            return const LoadingScreen(title: 'Wallet');
          }
          if (state is BankCardDetailsLoadedState) {
            return const BankCardDetailsMainScreen();
          }
          if (state is BankCardDetailsInfoState) {
            return const BankCardDetailsInfoScreen();
          }
          if (state is BankCardDetailsChoosePinState) {
            return BankCardDetailsChoosePinScreen();
          }
          if (state is BankCardDetailsConfirmPinState) {
            return const BankCardDetailsConfirmPinScreen();
          }
          if (state is BankCardDetailsAppleWalletState) {
            return const BankCardDetailsAppleWalletScreen();
          }
          if (state is BankCardDetailsActivationSuccessState) {
            return const BankCardDetailsActivationSuccessScreen();
          }
          if (state is BankCardActivatedState) {
            return const BankCardActivatedScreen();
          }
          if (state is BankCardDetailsErrorState) {
            return ErrorScreen(
              title: cardDetailsRoute.title,
              message: state.message,
            );
          }

          return const LoadingScreen(title: 'Wallet');
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class _CardDetailsOptions extends StatefulWidget {
  BankCard card;
  _CardDetailsOptions({super.key, required this.card});

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
                content:
                    'You can use your card to pay online. You can also disable this option.'),
            visibleSwitch: true,
          ),
          _CardOptionColumns(
            icon: Icons.atm,
            fieldName: 'ATM withdrawals',
            forMoreInfoTap: () => _buildPopup(
                title: 'ATM withdrawals',
                content:
                    'You can use your card to withdraw cash from ATMs. You can also disable this option.'),
            visibleSwitch: true,
          ),
          _CardOptionColumns(
            icon: Icons.contactless,
            fieldName: 'Contactless payments',
            forMoreInfoTap: () => _buildPopup(
                title: 'Contactless payments',
                content:
                    'You can use your card to pay contactless. You can also disable this option.'),
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
    super.key,
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
  const _CardOptionName({super.key, required this.name});

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
  const _CardOptionSwitch({super.key});

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
