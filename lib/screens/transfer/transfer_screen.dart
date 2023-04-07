import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';

import '../../widgets/platform_text_input.dart';
import '../../widgets/screen.dart';
import '../../cubits/transfer/transfer_cubit.dart';
import '../../widgets/spaced_column.dart';

class TransferScreen extends StatelessWidget {
  const TransferScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final person = context.read<AuthCubit>().state.user?.person;

    return BlocProvider.value(
      value: TransferCubit(),
      child: BlocBuilder<TransferCubit, TransferState>(
        builder: (context, state) {
          return Screen(
            title: "Transfer money",
            hideBottomNavbar: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Send from",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Replace empty Row widget with a child widget
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: true //TO DO
                            ? Colors.black
                            : const Color(0xFFEAECF0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 25.0,
                        horizontal: 16,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: const [
                              Text("asd"),
                            ],
                          ),
                          Row(
                            children: const [
                              Text("asd"),
                            ],
                          ),
                          Row(
                            children: const [
                              Text("asd"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SpacedColumn(
                    space: 16,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Payee information",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      PlatformTextInput(
                        textLabel: "Name of the person/business",
                        hintText: "e.g Solaris",
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                      PlatformTextInput(
                        textLabel: "IBAN",
                        hintText: "e.g DE84 1101 0101 4735 3658 36",
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
