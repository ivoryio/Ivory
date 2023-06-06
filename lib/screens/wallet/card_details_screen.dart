import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:go_router/go_router.dart';
import 'package:solarisdemo/models/debit_card.dart';

import '../../router/routing_constants.dart';
import '../../themes/default_theme.dart';
import '../../utilities/constants.dart';
import '../../widgets/screen.dart';

class CardDetailsScreenParams {
  final String cardId;

  CardDetailsScreenParams({required this.cardId});
}

class CardDetailsScreen extends StatelessWidget {
  final CardDetailsScreenParams params;

  const CardDetailsScreen({
    super.key,
    required this.params,
  });

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: cardDetailsRoute.title,
      centerTitle: true,
      hideBackButton: false,
      hideBottomNavbar: false,
      child: const Padding(
        padding: defaultScreenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              child: Card(
                color: Colors.grey,
                child: Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 65,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            _CardDetailsOptions()
          ],
        ),
      ),
    );
  }
}

class _CardDetailsOptions extends StatefulWidget {
  const _CardDetailsOptions({super.key});

  @override
  State<_CardDetailsOptions> createState() => __CardDetailsOptionsState();
}

class __CardDetailsOptionsState extends State<_CardDetailsOptions> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _CardOptionColumns(
            icon: Icons.local_atm, fieldName: 'Spending limit'),
        const SizedBox(height: 29),
        _CardOptionColumns(
          icon: Icons.payments,
          fieldName: 'Online payments',
          onAskMoreTap: () {
            log('go to Online payments screen');
          },
        ),
        const SizedBox(height: 29),
        _CardOptionColumns(
          icon: Icons.atm,
          fieldName: 'ATM withdrawals',
          onAskMoreTap: () {
            log('go to ATM withdrawal screen');
          },
        ),
        const SizedBox(height: 29),
        _CardOptionColumns(
          icon: Icons.contactless,
          fieldName: 'Contactless payments',
          onAskMoreTap: () {
            log('go to Contactless payments screen');
          },
        ),
      ],
    );
  }
}

class _CardOptionColumns extends StatelessWidget {
  final IconData icon;
  final String fieldName;
  final void Function()? onAskMoreTap;

  const _CardOptionColumns({
    super.key,
    required this.icon,
    required this.fieldName,
    this.onAskMoreTap,
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
                const SizedBox(width: 9.67),
                if (onAskMoreTap != null)
                  GestureDetector(
                    onTap: onAskMoreTap,
                    child: const Icon(
                      Icons.help_outline,
                    ),
                  ),
              ],
            ),
            const _CardOptionSwitch(),
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
    return Text(
      name,
      textAlign: TextAlign.left,
      style: Theme.of(context).textTheme.titleLarge,
    );
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
      duration: const Duration(milliseconds: 100),
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
