import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';

class FieldValidators extends StatefulWidget {
  final TextEditingController controller;
  final List<FieldValidator> validators;
  final VoidCallback? onValid;
  final VoidCallback? onInvalid;

  const FieldValidators({
    super.key,
    required this.controller,
    this.validators = const [],
    this.onValid,
    this.onInvalid,
  });

  @override
  State<FieldValidators> createState() => _FieldValidatorsState();
}

class _FieldValidatorsState extends State<FieldValidators> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_validate);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_validate);

    super.dispose();
  }

  void _validate() {
    if (isValidationComplete) {
      widget.onValid?.call();
    } else {
      widget.onInvalid?.call();
    }
  }

  bool get isActive => widget.controller.text.isNotEmpty;

  bool get isValidationComplete =>
      widget.controller.text.isNotEmpty &&
      widget.validators.every(
        (validator) => validator.validate(widget.controller.text),
      );

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, child) {
        List<Widget> items = [];

        for (var validator in widget.validators) {
          final isValid = validator.validate(widget.controller.text);

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
                          ? ClientConfig.getCustomColors().success
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
                            : ClientConfig.getCustomColors().neutral700,
                      ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: items,
        );
      },
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
