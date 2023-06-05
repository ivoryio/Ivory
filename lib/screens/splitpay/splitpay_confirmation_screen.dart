import 'package:flutter/material.dart';

import '../../models/transaction_model.dart';
import '../../widgets/screen.dart';

class SplitpayConfirmationScreen extends StatelessWidget {
  final Transaction transaction;

  const SplitpayConfirmationScreen({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return const Screen(
      title: 'Transaction confirmation',
      child: Column(
        children: [
          Text(
            'page 2',
          ),
        ],
      ),
    );
  }
}
