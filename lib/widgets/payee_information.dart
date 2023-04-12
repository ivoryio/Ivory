import 'package:flutter/widgets.dart';

import 'checkbox.dart';
import 'platform_text_input.dart';
import 'spaced_column.dart';

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