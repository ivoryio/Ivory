import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/models/transaction_model.dart';
import 'package:solarisdemo/widgets/screen.dart';

import '../../cubits/splitpay_cubit/splitpay_cubit.dart';
import '../../widgets/button.dart';

class SplitpaySelectionScreen extends StatelessWidget {
  final Transaction transaction;

  const SplitpaySelectionScreen({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: 'Convert into instalments',
      child: Column(
        children: [
          const Text(
            'page 1',
          ),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: PrimaryButton(
                text: "Convert into instalments",
                onPressed: () {
                  context.read<SplitpayCubit>().setSelected(transaction);
                }),
          ),
        ],
      ),
    );
  }
}
