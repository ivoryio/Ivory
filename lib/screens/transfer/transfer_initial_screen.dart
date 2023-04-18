import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/screen.dart';
import '../../widgets/checkbox.dart';
import '../../themes/default_theme.dart';
import '../../widgets/spaced_column.dart';
import '../../widgets/account_select.dart';
import '../../router/routing_constants.dart';
import '../../widgets/platform_text_input.dart';
import '../../widgets/sticky_bottom_content.dart';
import '../../cubits/transfer/transfer_cubit.dart';

class TransferInitialScreen extends StatelessWidget {
  final TransferState state;

  const TransferInitialScreen({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<PayeeInformationState> payeeInformationKey = GlobalKey();
    final GlobalKey<AccountSelectState> accountSelectKey = GlobalKey();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    final TextEditingController ibanController = TextEditingController(
      text: state.iban,
    );
    final TextEditingController nameController = TextEditingController(
      text: state.name,
    );

    return Screen(
      title: transferRoute.title,
      hideBottomNavbar: true,
      bottomStickyWidget: BottomStickyWidget(
        child: StickyBottomContent(
          onContinueCallback: () {
            if (formKey.currentState!.validate() &&
                accountSelectKey.currentState?.selectedAccount != null) {
              context.read<TransferCubit>().setBasicData(
                    iban: ibanController.text,
                    name: nameController.text,
                    savePayee: payeeInformationKey.currentState!.savePayee,
                    personAccount:
                        accountSelectKey.currentState!.selectedAccount,
                  );
            }
          },
        ),
      ),
      child: Padding(
        padding: defaultScreenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SpacedColumn(
              space: 32,
              children: [
                AccountSelect(
                  key: accountSelectKey,
                  title: "Send from",
                ),
                PayeeInformation(
                  formKey: formKey,
                  key: payeeInformationKey,
                  ibanController: ibanController,
                  nameController: nameController,
                  savePayee: state.savePayee,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class PayeeInformation extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController ibanController;
  final TextEditingController nameController;
  final bool? savePayee;

  const PayeeInformation({
    super.key,
    this.savePayee,
    required this.formKey,
    required this.ibanController,
    required this.nameController,
  });

  @override
  State<PayeeInformation> createState() => PayeeInformationState();
}

class PayeeInformationState extends State<PayeeInformation> {
  bool savePayee = false;

  @override
  void initState() {
    super.initState();
    savePayee = widget.savePayee ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: SpacedColumn(
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
            controller: widget.nameController,
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
                return 'Please enter the name of the person/business';
              }
              return null;
            },
          ),
          PlatformTextInput(
            controller: widget.ibanController,
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
                return 'Please enter the IBAN';
              }
              return null;
            },
          ),
          Row(
            children: [
              CheckboxWidget(
                isChecked: widget.savePayee ?? false,
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
      ),
    );
  }
}
