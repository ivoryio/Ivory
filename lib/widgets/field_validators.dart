import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';

class FieldValidators extends StatefulWidget {
  final List<TextEditingController> controllers;
  final List<FieldValidator> validators;

  const FieldValidators({
    super.key,
    this.controllers = const [],
    this.validators = const [],
  });

  @override
  State<FieldValidators> createState() => _FieldValidatorsState();
}

class _FieldValidatorsState extends State<FieldValidators> {
  late bool isActive;

  @override
  void initState() {
    super.initState();
    isActive = widget.controllers.every((controller) => controller.text.isNotEmpty);

    for (var controller in widget.controllers) {
      controller.addListener(() {
        if (isActive == false && controller.text.isNotEmpty) {
          setState(() {
            isActive = true;
          });
          return;
        }

        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];

    for (var validator in widget.validators) {
      final isValid = widget.controllers.every((controller) => validator.validate(controller.text));

      items.add(
        Row(
          children: [
            Icon(
              isActive
                  ? isValid
                      ? Icons.check
                      : Icons.close
                  : Icons.check,
              color: isActive
                  ? isValid
                      ? ClientConfig.getCustomColors().validCheck
                      : ClientConfig.getColorScheme().error
                  : ClientConfig.getCustomColors().neutral700,
            ),
            const SizedBox(width: 8),
            Text(
              validator.label,
              style: ClientConfig.getTextStyleScheme().bodySmallRegular.copyWith(
                  color: isActive
                      ? isValid
                          ? ClientConfig.getCustomColors().neutral900
                          : ClientConfig.getColorScheme().error
                      : ClientConfig.getCustomColors().neutral700),
            ),
          ],
        ),
      );
    }

    return Column(
      children: items,
    );
  }
}

class FieldValidator {
  final String label;
  final bool Function(String) validate;

  FieldValidator({
    required this.label,
    required this.validate,
  });
}

class CustomFieldValidators {
  static minCharacters(int length) => FieldValidator(
        label: 'Min. $length characters',
        validate: (value) => value.length >= length,
      );
  static minNumbers(int length) => FieldValidator(
        label: '$length Number',
        validate: (value) => value.replaceAll(RegExp(r'[^0-9]'), '').length >= length,
      );
  static uppercase() => FieldValidator(
        label: 'Uppercase',
        validate: (value) => value.contains(RegExp(r'[A-Z]')),
      );
  static lowercase() => FieldValidator(
        label: 'Lowercase',
        validate: (value) => value.contains(RegExp(r'[a-z]')),
      );
}
