import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyTextField extends StatefulWidget {
  final Color errorBorderColor;
  final Color focusedBorderColor;
  final Color unfocusedBorderColor;
  final EdgeInsets padding;
  final FocusNode? focusNode;
  final String currencySymbol;
  final TextEditingController? controller;
  final TextStyle decimalsTextStyle;
  final TextStyle digitsTextStyle;
  final bool error;
  final int decimals;
  final Color hintColor;

  const CurrencyTextField({
    super.key,
    this.controller,
    this.currencySymbol = "€",
    this.decimals = 2,
    this.error = false,
    this.errorBorderColor = Colors.red,
    this.focusNode,
    this.focusedBorderColor = Colors.black,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.unfocusedBorderColor = const Color(0xFFADADB4),
    this.hintColor = const Color(0xFFADADB4),
    this.digitsTextStyle = const TextStyle(
      fontSize: 40,
      height: 1.2,
      fontWeight: FontWeight.w600,
    ),
    this.decimalsTextStyle = const TextStyle(
      fontSize: 24,
      height: 2,
      fontWeight: FontWeight.w600,
    ),
  });

  @override
  State<CurrencyTextField> createState() => _CurrencyTextFieldState();
}

class _CurrencyTextFieldState extends State<CurrencyTextField> {
  late TextEditingController _controller;
  final TextEditingController _digitsController = TextEditingController();
  final TextEditingController _decimalsController = TextEditingController();
  late FocusNode _digitsFocusNode;
  final FocusNode _decimalsFocusNode = FocusNode();
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? TextEditingController(text: "0");
    _digitsFocusNode = widget.focusNode ?? FocusNode();

    _setControllersText(force: true);

    _controller.addListener(_setControllersText);
    _digitsController.addListener(_updateControllerValue);
    _decimalsController.addListener(_updateControllerValue);

    _digitsFocusNode.addListener(_onFocusChange);
    _decimalsFocusNode.addListener(_onFocusChange);
  }

  void _setControllersText({bool force = false}) {
    final number = double.tryParse(_controller.text) ?? 0;
    final numberFormatted = NumberFormat.currency(
      locale: "en_US",
      symbol: "${widget.currencySymbol} ",
      decimalDigits: widget.decimals,
    ).format(number);

    final numberParts = numberFormatted.split(".");

    if (force || (_digitsController.text.isNotEmpty && _digitsController.text != numberParts[0])) {
      _digitsController.text = numberParts[0];
    }
    if (force || (_decimalsController.text.isNotEmpty && _decimalsController.text != numberParts[1])) {
      _decimalsController.text = numberParts[1];

      if (_decimalsFocusNode.hasFocus) {
        _decimalsController.selection = TextSelection.collapsed(offset: _decimalsController.text.length);
      }
    }
  }

  void _updateControllerValue() {
    final digitsText = _digitsController.text.replaceAll(widget.currencySymbol, "").replaceAll(",", "").trim();
    final decimalsText = _decimalsController.text;

    final digits = int.tryParse(digitsText) ?? 0;
    final decimals = int.tryParse(decimalsText) ?? 0;

    final number = double.tryParse("$digits.$decimals") ?? 0;

    _controller.text = number.toStringAsFixed(widget.decimals);
  }

  void _onFocusChange() {
    setState(() {
      _hasFocus = _digitsFocusNode.hasFocus || _decimalsFocusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _digitsController.dispose();
    _decimalsController.dispose();
    _digitsFocusNode.dispose();
    _decimalsFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: widget.error
                  ? widget.errorBorderColor
                  : _hasFocus
                      ? widget.focusedBorderColor
                      : widget.unfocusedBorderColor,
              width: 2),
        ),
      ),
      padding: widget.padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IntrinsicWidth(
            child: TextField(
              controller: _digitsController,
              focusNode: _digitsFocusNode,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.end,
              inputFormatters: [
                // change focus to decimals when .(dot) is pressed
                TextInputFormatter.withFunction((oldValue, newValue) {
                  if (newValue.text.endsWith(".")) {
                    _decimalsFocusNode.requestFocus();
                    _decimalsController.selection = TextSelection.collapsed(offset: _decimalsController.text.length);
                    return oldValue;
                  }
                  return newValue;
                }),
                FilteringTextInputFormatter.digitsOnly,
                _CurrencyDigitsFormatter(
                  currencySymbol: widget.currencySymbol,
                ),
              ],
              style: widget.digitsTextStyle,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: "${widget.currencySymbol} 0",
                hintStyle: widget.digitsTextStyle.copyWith(color: widget.hintColor),
                isDense: true,
              ),
            ),
          ),
          Text(".", style: widget.digitsTextStyle),
          const SizedBox(width: 2),
          IntrinsicWidth(
            child: TextField(
              controller: _decimalsController,
              focusNode: _decimalsFocusNode,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(widget.decimals),
              ],
              style: widget.decimalsTextStyle,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: "0" * widget.decimals,
                hintStyle: widget.decimalsTextStyle.copyWith(color: widget.hintColor),
                isDense: true,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _CurrencyDigitsFormatter extends TextInputFormatter {
  final int maxLength = 8;
  final String currencySymbol;

  _CurrencyDigitsFormatter({
    this.currencySymbol = "€",
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final matchOnlyDigits = RegExp(r"^\d+$");
    final digits = (matchOnlyDigits.stringMatch(newValue.text) ?? "").trim();

    final digitsInt = int.tryParse(digits);

    if (digits.isEmpty || digitsInt == null) {
      return newValue.copyWith(
        text: "",
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else if (digits.length > maxLength) {
      return oldValue;
    }

    final digitsFormatted = NumberFormat.currency(
      locale: "en_US",
      symbol: "$currencySymbol ", // symbol followed by a space
      decimalDigits: 0,
    ).format(digitsInt);

    return newValue.copyWith(
      text: digitsFormatted,
      selection: TextSelection.collapsed(offset: digitsFormatted.length),
    );
  }
}
