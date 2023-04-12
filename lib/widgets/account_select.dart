import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../cubits/auth_cubit/auth_cubit.dart';
import '../models/user.dart';
import '../screens/home/modals/new_transfer_popup.dart';
import '../utilities/format.dart';
import 'spaced_column.dart';

class AccountSelect extends StatelessWidget {
  final String? title;
  const AccountSelect({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    AuthenticatedUser? user = context.read<AuthCubit>().state.user;

    String fullName =
        '${user?.person.firstName ?? ""} ${user?.person.lastName ?? ""}';
    String iban = Format.iban(user?.personAccount.iban ?? "");

    return SpacedColumn(
      space: 16,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          const Text(
            "Send from",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 16,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.black,
            ),
          ),
          child: SpacedColumn(
            space: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xffE6E6E6),
                ),
                child: const Text("Main account",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    fullName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 20 / 16,
                    ),
                  ),
                  const RadioButton(
                    checked: true,
                  )
                ],
              ),
              Text(iban,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 17 / 14,
                    color: Color(0xff667085),
                  )),
            ],
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}