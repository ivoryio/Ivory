import 'dart:math';

import 'package:flutter/material.dart';

import 'constants.dart';

class CurrencyTextFieldController extends TextEditingController {
  final int _maxDigits, _numberOfDecimals;
  final String _currencySymbol,
      _decimalSymbol,
      _thousandSymbol,
      _currencySeparator;
  final bool _currencyOnLeft, _enableNegative;
  String _previewsText = '';
  double _value = 0.0;

  final _onlyNumbersRegex = RegExp(r'[^\d]');
  bool _isNegative = false;

  double get doubleValue => _value.toPrecision(_numberOfDecimals);
  String get currencySymbol => _currencySymbol;
  String get decimalSymbol => _decimalSymbol;
  String get thousandSymbol => _thousandSymbol;
  int get intValue =>
      (_isNegative ? -1 : 1) *
      (int.tryParse(_getOnlyNumbers(string: text) ?? '') ?? 0);

  CurrencyTextFieldController({
    String currencySymbol = defaultCurrencySymbol,
    String decimalSymbol = ',',
    String thousandSymbol = '.',
    String currencySeparator = ' ',
    double? initDoubleValue,
    int? initIntValue,
    int maxDigits = 15,
    int numberOfDecimals = 2,
    bool currencyOnLeft = true,
    bool enableNegative = true,
  })  : assert(
          !(initDoubleValue != null && initIntValue != null),
          "You must set either 'initDoubleValue' or 'initIntValue' parameter",
        ),
        _currencySymbol = currencySymbol,
        _decimalSymbol = decimalSymbol,
        _thousandSymbol = thousandSymbol,
        _currencySeparator = currencySeparator,
        _maxDigits = maxDigits,
        _numberOfDecimals = numberOfDecimals,
        _currencyOnLeft = currencyOnLeft,
        _enableNegative = enableNegative {
    if (initDoubleValue != null) {
      _value = initDoubleValue;
      initValue();
    } else if (initIntValue != null) {
      _value = initIntValue / 100;
      initValue();
    }
    addListener(_listener);
  }

  void _listener() {
    if (_previewsText == text) {
      _setSelectionBy(offset: text.length);
      return;
    }

    checkNegative();

    late String clearText;

    if (_currencyOnLeft) {
      clearText = (_getOnlyNumbers(string: text) ?? '').trim();
    } else {
      if (text.lastChars(1).isNumeric()) {
        clearText = (_getOnlyNumbers(string: text) ?? '').trim();
      } else {
        clearText =
            (_getOnlyNumbers(string: text) ?? '').trim().allBeforeLastN(1);
      }
    }

    if (clearText.isEmpty) {
      zeroValue();
      return;
    }

    if (clearText.length > _maxDigits) {
      text = _previewsText;
      return;
    }

    if ((double.tryParse(clearText) ?? 0.0) == 0.0) {
      zeroValue();
      return;
    }

    _value = _getDoubleValueFor(string: clearText);

    final String maskedValue = _composeCurrency(_applyMaskTo(value: _value));

    _previewsText = maskedValue;

    text = maskedValue;

    _setSelectionBy(offset: text.length);
  }

  void initValue() {
    if (_value < 0) {
      if (!_enableNegative) {
        _value = _value * -1;
      } else {
        _isNegative = true;
      }
    }
    _previewsText = _composeCurrency(_applyMaskTo(value: _value));
    text = _previewsText;
    _setSelectionBy(offset: text.length);
  }

  void checkNegative() {
    if (_enableNegative) {
      _isNegative = text.startsWith('-');
    } else {
      _isNegative = false;
    }
  }

  void _setSelectionBy({required int offset}) {
    selection = TextSelection.fromPosition(TextPosition(offset: offset));
  }

  void zeroValue() {
    _value = 0;
    _previewsText = _negativeSign();
    text = _previewsText;
  }

  String? _getOnlyNumbers({String? string}) =>
      string?.replaceAll(_onlyNumbersRegex, '');

  double _getDoubleValueFor({required String string}) {
    return (_isNegative ? -1 : 1) *
        (double.tryParse(string) ?? 0.0) /
        pow(10, _numberOfDecimals);
  }

  String _composeCurrency(String value) {
    return _currencyOnLeft
        ? '${_negativeSign()}$_currencySymbol$_currencySeparator$value'
        : '${_negativeSign()}$value$_currencySeparator$_currencySymbol';
  }

  String _negativeSign() {
    return (_isNegative ? '-' : '');
  }

  String _applyMaskTo({required double value}) {
    final List<String> textRepresentation = value
        .toStringAsFixed(_numberOfDecimals)
        .replaceAll('.', '')
        .replaceAll('-', '')
        .split('')
        .reversed
        .toList(growable: true);

    textRepresentation.insert(_numberOfDecimals, _decimalSymbol);

    int thousandPositionSymbol = _numberOfDecimals + 4;
    while (textRepresentation.length > thousandPositionSymbol) {
      textRepresentation.insert(thousandPositionSymbol, _thousandSymbol);
      thousandPositionSymbol += 4;
    }

    return textRepresentation.reversed.join();
  }

  @override
  void dispose() {
    removeListener(_listener);
    super.dispose();
  }
}

extension Precision on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}

extension E on String {
  String lastChars(int n) => substring(length - n);
  bool isNumeric() => double.tryParse(this) != null;
  String allBeforeLastN(int n) => substring(0, length - n);
}
