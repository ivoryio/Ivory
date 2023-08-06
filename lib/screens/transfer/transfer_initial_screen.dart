import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/utilities/constants.dart';
import 'package:solarisdemo/utilities/format.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

import '../../cubits/transfer/transfer_cubit.dart';
import '../../utilities/validator.dart';
import '../../widgets/account_select.dart';
import '../../widgets/checkbox.dart';
import '../../widgets/platform_text_input.dart';
import '../../widgets/screen.dart';
import '../../widgets/spaced_column.dart';
import '../../widgets/sticky_bottom_content.dart';

class TransferInitialScreen extends StatelessWidget {
  static const String route = "/transferInitialScreen";

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
    final GlobalKey<StickyBottomContentState> stickyBottomContentKey =
        GlobalKey();

    final TextEditingController nameController = TextEditingController(
      text: state.name ?? emptyStringValue,
    );
    final TextEditingController ibanController = TextEditingController(
      text: state.iban ?? emptyStringValue,
    );
    final TextEditingController descriptionController = TextEditingController(
      text: state.description ?? emptyStringValue,
    );

    bool inputsNotEmpty() {
      return nameController.text.isNotEmpty &&
          ibanController.text.isNotEmpty &&
          descriptionController.text.isNotEmpty;
    }

    void changeListener() {
      bool buttonActive = stickyBottomContentKey.currentState!.buttonActive;
      bool isEmpty = !inputsNotEmpty();

      if (buttonActive && isEmpty) {
        stickyBottomContentKey.currentState!.setButtonDisabled();
      }

      if (!buttonActive && !isEmpty) {
        stickyBottomContentKey.currentState!.setButtonEnabled();
      }
    }

    nameController.addListener(changeListener);
    ibanController.addListener(changeListener);
    descriptionController.addListener(changeListener);

    return ScreenScaffold(
      body: ScrollableScreenContainer(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const AppToolbar(title: "Transfer"),
                  AccountSelect(
                    key: accountSelectKey,
                    title: "Send from",
                  ),
                  const SizedBox(height: 32),
                  PayeeInformation(
                    formKey: formKey,
                    key: payeeInformationKey,
                    ibanController: ibanController,
                    nameController: nameController,
                    descriptionController: descriptionController,
                    savePayee: state.savePayee,
                  ),
                ],
              ),
            ),
            const Spacer(),
            BottomStickyWidget(
              child: StickyBottomContent(
                key: stickyBottomContentKey,
                buttonActive: inputsNotEmpty(),
                onContinueCallback: () {
                  if (formKey.currentState!.validate() &&
                      accountSelectKey.currentState?.selectedAccount != null) {
                    context.read<TransferCubit>().setBasicData(
                          iban: ibanController.text,
                          name: nameController.text,
                          description: descriptionController.text,
                          savePayee:
                              payeeInformationKey.currentState!.savePayee,
                          personAccount:
                              accountSelectKey.currentState!.selectedAccount,
                        );
                  }
                },
              ),
            ),
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
  final TextEditingController descriptionController;
  final bool? savePayee;

  const PayeeInformation({
    super.key,
    this.savePayee,
    required this.formKey,
    required this.ibanController,
    required this.nameController,
    required this.descriptionController,
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
            hintText: "e.g DE01 1234 1234 1234 1234 12",
            inputFormatters: [InputFormatter.iban],
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the IBAN';
              }
              if (!Validator.isValidIban(value)) {
                return 'Please enter a valid IBAN';
              }
              return null;
            },
          ),
          PlatformTextInput(
            controller: widget.descriptionController,
            textLabel: "Description",
            textLabelStyle: const TextStyle(
              color: Color(0xFF344054),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            hintText: "e.g Rent",
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
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
