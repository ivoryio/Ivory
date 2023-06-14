import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:solarisdemo/cubits/debit_card_details_cubit/debit_card_details_cubit.dart';
import 'package:solarisdemo/cubits/debit_card_details_cubit/debit_card_details_state.dart';
import 'package:solarisdemo/models/debit_card.dart';
import 'package:solarisdemo/services/debit_card_service.dart';
import 'package:solarisdemo/widgets/spaced_column.dart';

import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../models/user.dart';
import '../../router/routing_constants.dart';
import '../../themes/default_theme.dart';
import '../../widgets/debit_card_widget.dart';
import '../../widgets/screen.dart';

class CardDetailsScreen extends StatelessWidget {
  final DebitCard card;

  const CardDetailsScreen({
    super.key,
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    AuthenticatedUser user = context.read<AuthCubit>().state.user!;
    return BlocProvider.value(
      value: DebitCardDetailsCubit(
        debitCardsService: DebitCardsService(user: user.cognito),
      )..loadDebitCard(card.id),
      child: BlocBuilder<DebitCardDetailsCubit, DebitCardDetailsState>(
        builder: (context, state) {
          if (state is DebitCardDetailsLoadingState) {
            return const LoadingScreen(title: 'Card details');
          }
          if (state is DebitCardDetailsLoadedState) {
            return Screen(
              scrollPhysics: const NeverScrollableScrollPhysics(),
              title: cardDetailsRoute.title,
              centerTitle: true,
              hideBackButton: false,
              hideBottomNavbar: false,
              child: Padding(
                padding: defaultScreenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SpacedColumn(
                      space: 20,
                      children: [
                        DebitCardWidget(
                          cardNumber:
                              state.debitCard!.representation!.maskedPan!,
                          cardHolder: state.debitCard!.representation!.line1!,
                          cardExpiry: state.debitCard!.representation!
                              .formattedExpirationDate!,
                          isViewable: false,
                        ),
                        _CardDetailsOptions(card: state.debitCard ?? card),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is DebitCardDetailsErrorState) {
            return ErrorScreen(
              title: cardDetailsRoute.title,
              message: state.message,
            );
          }

          return const LoadingScreen(title: 'Error');
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class _CardDetailsOptions extends StatefulWidget {
  DebitCard card;
  _CardDetailsOptions({super.key, required this.card});

  @override
  State<_CardDetailsOptions> createState() => __CardDetailsOptionsState();
}

class __CardDetailsOptionsState extends State<_CardDetailsOptions> {
  void _buildPopup({required String title, required String content}) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final optionWidgets = [
      SpacedColumn(
        space: 29,
        children: [
          const _CardOptionColumns(
            icon: Icons.local_atm,
            fieldName: 'Spending limit',
            visibleSwitch: false,
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
          Divider(
            color: Theme.of(context).primaryColor,
            height: 26.5,
          ),
          if (widget.card.status == DebitCardStatus.ACTIVE)
            GestureDetector(
              onTap: () async {
                context.read<DebitCardDetailsCubit>().freezeDebitCard(
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
          if (widget.card.status == DebitCardStatus.BLOCKED)
            GestureDetector(
              onTap: () async {
                context.read<DebitCardDetailsCubit>().unfreezeDebitCard(
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
    return Container(
      height: (MediaQuery.of(context).size.height * 0.8) - 174,
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: optionWidgets.length,
        itemBuilder: (context, index) => optionWidgets[index],
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
      ),
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
      inactiveColor: Color(0xFFB0B0B0),
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
