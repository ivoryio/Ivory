import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class IvoryAmountField extends StatefulWidget {
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

  const IvoryAmountField({
    super.key,
    this.controller,
    this.currencySymbol = "€",
    this.decimals = 2,
    this.error = false,
    this.errorBorderColor = Colors.red,
    this.focusNode,
    this.focusedBorderColor = Colors.black,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    required this.unfocusedBorderColor,
    required this.hintColor,
    this.digitsTextStyle = const TextStyle(
      fontSize: 40,
      height: 1.2,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    this.decimalsTextStyle = const TextStyle(
      fontSize: 24,
      height: 2,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  });

  @override
  State<IvoryAmountField> createState() => _IvoryAmountFieldState();
}

class _IvoryAmountFieldState extends State<IvoryAmountField> {
  late TextEditingController _controller;
  late TextEditingController _digitsController;
  late TextEditingController _decimalsController;
  late FocusNode _digitsFocusNode;
  late FocusNode _decimalsFocusNode = FocusNode();
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? TextEditingController();

    final [digitsText, decimalsText] = _getFormattedTextValues(_controller.text);

    _digitsController = TextEditingController(text: _controller.text.isNotEmpty ? digitsText : "");
    _digitsFocusNode = widget.focusNode ?? FocusNode();

    _decimalsController = TextEditingController(text: _controller.text.isNotEmpty ? decimalsText : "");
    _decimalsFocusNode = FocusNode();

    _digitsController.addListener(_updateControllerValue);
    _decimalsController.addListener(_updateControllerValue);

    _digitsFocusNode.addListener(_onFocusChange);
    _decimalsFocusNode.addListener(_onFocusChange);
  }

  double get doubleValue {
    final digitsText = _digitsController.text.replaceAll(widget.currencySymbol, "").replaceAll(",", "").trim();
    final decimalsText = _decimalsController.text;

    final digits = int.tryParse(digitsText) ?? 0;
    final decimals = int.tryParse(decimalsText) != null ? decimalsText : 0;

    return double.tryParse("$digits.$decimals") ?? 0;
  }

  List<String> _getFormattedTextValues(String text) {
    final doubleValue = double.tryParse(text) ?? 0;
    final numberFormatted = NumberFormat.currency(
      locale: "en_US",
      symbol: "${widget.currencySymbol} ",
    ).format(doubleValue);

    return numberFormatted.toString().split(".");
  }

  void _updateControllerValue() {
    setState(() {}); // rebuild to update the color of the dot

    final newText = doubleValue.toStringAsFixed(widget.decimals);
    final formatted = _getFormattedTextValues(newText);

    const singleDigit = 1;
    const singleDigitWithCurrencySymbol = 3;

    if (_controller.text == newText) {
      return;
    }

    if (_digitsController.text.length == singleDigitWithCurrencySymbol && _decimalsController.text.isEmpty) {
      _decimalsController.text = formatted[1];
    }
    if (_decimalsController.text.length == singleDigit && _digitsController.text.isEmpty) {
      _digitsController.text = formatted[0];
    }

    _controller.text = newText;
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
                    _decimalsController.text = "";
                    _decimalsController.selection = const TextSelection.collapsed(offset: 0);
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
                hintStyle: widget.digitsTextStyle.copyWith(
                  color: widget.hintColor,
                ),
                isDense: true,
              ),
            ),
          ),
          Text(
            ".",
            style: widget.digitsTextStyle.copyWith(
              color: _digitsController.text.isNotEmpty || _decimalsController.text.isNotEmpty
                  ? widget.digitsTextStyle.color
                  : widget.hintColor,
            ),
          ),
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
                hintStyle: widget.decimalsTextStyle.copyWith(
                  color: widget.hintColor,
                ),
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
