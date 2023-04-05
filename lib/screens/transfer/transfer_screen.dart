import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/screen.dart';
import '../../router/routing_constants.dart';
import '../../cubits/transfer/transfer_cubit.dart';

class TransferScreen extends StatelessWidget {
  const TransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: TransferCubit(),
      child: BlocBuilder<TransferCubit, TransferState>(
        builder: (context, state) {
          log('TransferScreen: $state');

          return Screen(
            title: transferRoute.title,
            hideBottomNavbar: true,
            child: const Center(
              child: Text('Wallet'),
            ),
          );
        },
      ),
    );
  }
}
