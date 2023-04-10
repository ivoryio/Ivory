import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';
import 'package:solarisdemo/models/person_account.dart';
import 'package:solarisdemo/models/user.dart';

import '../../utilities/format.dart';
import '../../widgets/button.dart';
import '../../widgets/screen.dart';
import '../../widgets/checkbox.dart';
import '../../themes/default_theme.dart';
import '../../widgets/spaced_column.dart';
import '../../router/routing_constants.dart';
import '../home/modals/new_transfer_popup.dart';
import '../../widgets/platform_text_input.dart';
import '../../cubits/transfer/transfer_cubit.dart';

class TransferScreen extends StatelessWidget {
  final TransferScreenParams transferScreenParams;

  const TransferScreen({
    super.key,
    required this.transferScreenParams,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: TransferCubit(),
      child: BlocBuilder<TransferCubit, TransferState>(
        builder: (context, state) {
          return Screen(
            title: transferRoute.title,
            hideBottomNavbar: true,
            bottomStickyWidget: const BottomStickyWidget(
              child: StickyBottomContent(),
            ),
            child: Padding(
              padding: defaultScreenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  AccountSelect(),
                  PayeeInformation(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

enum TransferType { person, business }

class TransferScreenParams {
  final TransferType transferType;

  const TransferScreenParams({
    required this.transferType,
  });
}

class StickyBottomContent extends StatelessWidget {
  const StickyBottomContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: defaultScreenPadding,
      child: Row(
        children: [
          Expanded(
            child: PrimaryButton(
              text: "Continue",
              onPressed: () {
                log("Continue pressed");
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AccountSelect extends StatelessWidget {
  const AccountSelect({super.key});

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

class PayeeInformation extends StatefulWidget {
  const PayeeInformation({super.key});

  @override
  State<PayeeInformation> createState() => _PayeeInformationState();
}

class _PayeeInformationState extends State<PayeeInformation> {
  bool _isSavePayee = false;

  @override
  Widget build(BuildContext context) {
    return SpacedColumn(
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
          textLabelStyle: const TextStyle(
            color: Color(0xFF344054),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
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
          textLabelStyle: const TextStyle(
            color: Color(0xFF344054),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          hintText: "e.g DE84 1101 0101 4735 3658 36",
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            return null;
          },
        ),
        Row(
          children: [
            CheckboxWidget(
              isChecked: _isSavePayee,
              onChanged: (bool checked) {
                setState(() {
                  _isSavePayee = checked;
                });
              },
            ),
            const SizedBox(width: 12),
            const Text(
              "Save the payee for future transfers",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
