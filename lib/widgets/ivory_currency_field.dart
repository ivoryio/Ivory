import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:solarisdemo/config.dart';

class InputCurrencyField extends StatefulWidget {
  final String currencyPathIcon;
  final TextEditingController? controller;
  final String? label;
  final Widget? labelSuffix;
  final String? placeHolder;
  final FocusNode? focusNode;

  const InputCurrencyField({
    super.key,
    required this.currencyPathIcon,
    this.controller,
    this.label,
    this.labelSuffix,
    this.placeHolder = '0.00',
    this.focusNode,
  });

  @override
  State<InputCurrencyField> createState() => _InputCurrencyFieldState();
}

class _InputCurrencyFieldState extends State<InputCurrencyField> {
  TextEditingController _currencyController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  // final RegExp regExp = RegExp(r'^\d+\.?\d*$');

  @override
  void initState() {
    super.initState();

    _currencyController = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();

    _focusNode.addListener(() {
      setState(() {});
    });
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                decoration: BoxDecoration(
                    color: ClientConfig.getCustomColors().neutral100,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                    border: Border(
                      top: BorderSide(
                        width: _focusNode.hasFocus ? 1 : 0,
                        color: _focusNode.hasFocus ? ClientConfig.getColorScheme().primary : const Color(0x0FFFFFF),
                      ),
                      right: BorderSide(
                        width: _focusNode.hasFocus ? 0 : 1,
                        color: _focusNode.hasFocus ? ClientConfig.getColorScheme().primary : const Color(0x00FFFFFF),
                      ),
                      bottom: BorderSide(
                        width: _focusNode.hasFocus ? 1 : 0,
                        color: _focusNode.hasFocus ? ClientConfig.getColorScheme().primary : const Color(0x00FFFFFF),
                      ),
                      left: BorderSide(
                        width: _focusNode.hasFocus ? 1 : 0,
                        color: _focusNode.hasFocus ? ClientConfig.getColorScheme().primary : const Color(0x00FFFFFF),
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
              Expanded(
                child: TextField(
                  style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                  controller: _currencyController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  focusNode: _focusNode,
                  decoration: InputDecoration(
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
