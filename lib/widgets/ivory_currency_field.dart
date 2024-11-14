import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:solarisdemo/config.dart';

class InputCurrencyField extends StatefulWidget {
  final String currencyPathIcon;
  final TextEditingController? controller;
  final String? label;
  final Widget? labelSuffix;
  final String? placeHolder;
  final FocusNode? focusNode;
  final int? maxLength;

  const InputCurrencyField({
    super.key,
    required this.currencyPathIcon,
    this.controller,
    this.label,
    this.labelSuffix,
    this.placeHolder = '0.00',
    this.focusNode,
    this.maxLength,
  });

  @override
  State<InputCurrencyField> createState() => _InputCurrencyFieldState();
}

class _InputCurrencyFieldState extends State<InputCurrencyField> {
  TextEditingController _currencyController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _currencyController = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.label != null) ...[
          Row(
            children: [
              Text(
                widget.label!,
                style: ClientConfig.getTextStyleScheme().labelSmall,
              ),
              if (widget.labelSuffix != null) ...[
                const SizedBox(width: 4),
                widget.labelSuffix!,
              ],
            ],
          ),
          const SizedBox(height: 8),
        ],
        Container(
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              style: BorderStyle.solid,
              color: ClientConfig.getCustomColors().neutral400,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: ClientConfig.getCustomColors().neutral100,
          ),
          child: Row(
            children: [
              ListenableBuilder(
                listenable: _focusNode,
                builder: ((context, child) => Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                          decoration: BoxDecoration(
                              color: ClientConfig.getCustomColors().neutral100,
                              borderRadius:
                                  const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                              border: Border(
                                top: BorderSide(
                                  width: 1,
                                  color: _focusNode.hasFocus
                                      ? ClientConfig.getColorScheme().primary
                                      : const Color(0x00FFFFFF),
                                ),
                                right: BorderSide(
                                  width: 1,
                                  color: _focusNode.hasFocus
                                      ? ClientConfig.getColorScheme().primary
                                      : const Color(0x00FFFFFF),
                                ),
                                bottom: BorderSide(
                                  width: 1,
                                  color: _focusNode.hasFocus
                                      ? ClientConfig.getColorScheme().primary
                                      : const Color(0x00FFFFFF),
                                ),
                                left: BorderSide(
                                  width: 1,
                                  color: _focusNode.hasFocus
                                      ? ClientConfig.getColorScheme().primary
                                      : const Color(0x00FFFFFF),
                                ),
                              )),
                          child: SvgPicture.asset(
                            widget.currencyPathIcon,
                            width: 24,
                            height: 24,
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (!_focusNode.hasFocus) ...[
                          SizedBox(
                            width: 1,
                            height: 48,
                            child: VerticalDivider(
                              width: 1,
                              thickness: 1,
                              color: ClientConfig.getCustomColors().neutral400,
                            ),
                          )
                        ],
                      ],
                    )),
              ),
              Expanded(
                child: TextField(
                  maxLength: widget.maxLength,
                  style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                  controller: _currencyController,
                  focusNode: _focusNode,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    ThousandsSeparatorInputFormatter(),
                  ],
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: widget.placeHolder,
                    hintStyle: ClientConfig.getTextStyleScheme()
                        .bodyLargeRegular
                        .copyWith(color: ClientConfig.getCustomColors().neutral400),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: const OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                      borderSide: BorderSide(
                        width: 1,
                        color: ClientConfig.getColorScheme().primary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      final int selectionIndexFromTheRight = newValue.text.length - newValue.selection.end;

      final formattedValue = _formatInput(newValue.text);

      return TextEditingValue(
        text: formattedValue,
        selection: TextSelection.collapsed(offset: formattedValue.length - selectionIndexFromTheRight),
      );
    } else {
      return newValue;
    }
  }

  String _formatInput(String input) {
    final onlyNumbers = input.replaceAll(RegExp(r'[^0-9.]'), '');
    final integerAndDecimalValues = onlyNumbers.split('.');
    final integerValueFormatted = _formatIntegerPart(integerAndDecimalValues[0]);

    final wholeNumberFormatted = integerAndDecimalValues.length == 1
        ? integerValueFormatted
        : '$integerValueFormatted.${integerAndDecimalValues[1]}';

    return wholeNumberFormatted;
  }

  String _formatIntegerPart(String integerValueOfNumber) {
    return integerValueOfNumber.isNotEmpty ? NumberFormat('#,###').format(double.parse(integerValueOfNumber)) : '';
  }
}
