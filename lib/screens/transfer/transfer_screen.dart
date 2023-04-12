import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/widgets/platform_currency_input.dart';

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
  final GlobalKey<PayeeInformationState> payeeInformationKey = GlobalKey();
  final GlobalKey<AmountInformationState> amountInformationKey = GlobalKey();

  TransferScreen({
    super.key,
    required this.transferScreenParams,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: TransferCubit(),
      child: BlocBuilder<TransferCubit, TransferState>(
        builder: (context, state) {
          TransferCubit transferCubit = context.read<TransferCubit>();

          switch (transferCubit.state.runtimeType) {
            case TransferInitialState:
              return Screen(
                title: transferRoute.title,
                hideBottomNavbar: true,
                bottomStickyWidget: BottomStickyWidget(
                  child: StickyBottomContent(
                    onContinueCallback: () {
                      context.read<TransferCubit>().setBasicData(
                            iban: payeeInformationKey
                                .currentState!.ibanController.text,
                            name: payeeInformationKey
                                .currentState!.nameController.text,
                            savePayee:
                                payeeInformationKey.currentState!.savePayee,
                          );
                    },
                  ),
                ),
                child: Padding(
                  padding: defaultScreenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AccountSelect(),
                      PayeeInformation(
                        key: payeeInformationKey,
                        iban: state.iban,
                        name: state.name,
                        savePayee: state.savePayee,
                      ),
                    ],
                  ),
                ),
              );
            case TransferStateSetAmount:
              return Screen(
                customBackButtonCallback: () {
                  context.read<TransferCubit>().setInitState(
                        name: state.name,
                        iban: state.iban,
                        savePayee: state.savePayee,
                      );
                },
                title: transferRoute.title,
                hideBottomNavbar: true,
                bottomStickyWidget: BottomStickyWidget(
                  child: StickyBottomContent(
                    buttonText: "Send money",
                    onContinueCallback: () {
                      final amount = double.tryParse(amountInformationKey
                          .currentState!._amountController.text);
                      if (amount != null) {
                        context.read<TransferCubit>().setAmount(amount: amount);
                      }
                    },
                  ),
                ),
                child: Padding(
                  padding: defaultScreenPadding,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AmountInformation(
                          key: amountInformationKey,
                          amount: state.amount,
                        )
                      ]),
                ),
              );
            case TransferStateConfirm:
              return Screen(
                customBackButtonCallback: () {
                  context.read<TransferCubit>().setBasicData(
                        name: state.name,
                        iban: state.iban,
                        savePayee: state.savePayee,
                        amount: state.amount,
                      );
                },
                title: "Transaction confirmation",
                hideBottomNavbar: true,
                bottomStickyWidget: BottomStickyWidget(
                  child: StickyBottomContent(
                    buttonText: "Confirm and send",
                    onContinueCallback: () {
                      context.read<TransferCubit>().confirmTransfer(
                            name: state.name,
                            iban: state.iban,
                            savePayee: state.savePayee,
                            amount: state.amount,
                          );
                    },
                  ),
                ),
                child: Padding(
                  padding: defaultScreenPadding,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('TransferStateConfirm'),
                      ]),
                ),
              );
            case TransactionStateConfirmed:
              return Screen(
                title: '',
                hideBackButton: true,
                hideBottomNavbar: true,
                bottomStickyWidget: BottomStickyWidget(
                  child: StickyBottomContent(
                    buttonText: "OK, got it",
                    onContinueCallback: () {
                      context.go(homeRoute.path);
                    },
                  ),
                ),
                child: Padding(
                  padding: defaultScreenPadding,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('TransactionStateConfirmed'),
                      ]),
                ),
              );
            default:
              return const Text('Unknown state');
          }
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
  final Function onContinueCallback;
  final String? buttonText;
  const StickyBottomContent(
      {super.key,
      required this.onContinueCallback,
      this.buttonText = "Continue"});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: defaultScreenPadding,
      child: Row(
        children: [
          Expanded(
            child: PrimaryButton(
              text: buttonText!,
              onPressed: onContinueCallback,
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
  final String? iban;
  final String? name;
  final bool? savePayee;

  const PayeeInformation({super.key, this.iban, this.name, this.savePayee});

  @override
  State<PayeeInformation> createState() => PayeeInformationState();
}

class PayeeInformationState extends State<PayeeInformation> {
  bool savePayee = false;
  TextEditingController ibanController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ibanController.text = widget.iban ?? '';
    nameController.text = widget.name ?? '';
    savePayee = widget.savePayee ?? false;
  }

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
          controller: nameController,
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
          controller: ibanController,
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
              isChecked: savePayee,
              onChanged: (bool checked) {
                setState(() {
                  savePayee = checked;
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

class AmountInformation extends StatefulWidget {
  final double? amount;

  const AmountInformation({super.key, this.amount});

  @override
  State<AmountInformation> createState() => AmountInformationState();
}

class AmountInformationState extends State<AmountInformation> {
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.amount?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Enter Amount:'),
        const SizedBox(height: 8),
        PlatformCurrencyInput(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
            controller: _amountController),
      ],
    );
  }
}
