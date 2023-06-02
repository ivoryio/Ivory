import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../router/routing_constants.dart';
import '../../themes/default_theme.dart';
import '../../widgets/screen.dart';

class CardDetailsScreenParams {
  final String cardId;

  CardDetailsScreenParams({required this.cardId});
}

class CardDetailsScreen extends StatelessWidget {
  final CardDetailsScreenParams params;

  const CardDetailsScreen({super.key, required this.params});

  @override
  Widget build(BuildContext context) {
    inspect(params);
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
  bool _isSpendingLimitEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Spending limit: ',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Switch(
              value: _isSpendingLimitEnabled,
              activeColor: Colors.cyan,
              onChanged: (value) => {
                setState(() {
                  _isSpendingLimitEnabled = value;
                })
              },
            ),
          ],
        )
      ],
    );
  }
}
